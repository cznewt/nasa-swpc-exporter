
import os
import requests
import time
from prometheus_client import start_http_server, Gauge
import logging

logging.basicConfig(
    format="%(asctime)s [%(levelname)-5.5s]  %(message)s",
    level=logging.INFO,
    handlers=[
        logging.StreamHandler()
    ])

SWPC_SOLAR_WIND_PLASMA_URL = 'http://services.swpc.noaa.gov/products/solar-wind/plasma-1-day.json'
SWPC_SOLAR_WIND_MAG_URL = 'http://services.swpc.noaa.gov/products/solar-wind/mag-1-day.json'
SWPC_KP_INDEX_URL = 'https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json'
SWPC_XRAY_FLUX_URL = 'https://services.swpc.noaa.gov/json/goes/primary/xrays-1-day.json'
SWPC_PROTON_FLUX_URL = 'https://services.swpc.noaa.gov/json/goes/primary/integral-protons-1-day.json'

SWPC_MEASURE_INTERVAL = int(os.getenv('SWPC_MEASURE_INTERVAL', 60))
SWPC_LISTEN_PORT =  int(os.getenv('SWPC_LISTEN_PORT', 9468))
SWPC_COLLECTORS =  os.getenv('SWPC_COLLECTORS', 'solar_wind_plasma,solar_wind_mag,kp_index,xray_flux,proton_flux').split(',')

if 'solar_wind_plasma' in SWPC_COLLECTORS:
    solar_wind_plasma_density = Gauge('solar_wind_plasma_density', 'Solar wind plasma particle density')
    solar_wind_plasma_speed = Gauge('solar_wind_plasma_speed', 'Solar wind plasma speed')
    solar_wind_plasma_temp = Gauge('solar_wind_plasma_temperature', 'Solar wind plasma temperature')

if 'solar_wind_mag' in SWPC_COLLECTORS:
    solar_wind_mag_bx = Gauge('solar_wind_mag_bx', 'Solar wind magnetic field bx')
    solar_wind_mag_by = Gauge('solar_wind_mag_by', 'Solar wind magnetic field by')
    solar_wind_mag_bz = Gauge('solar_wind_mag_bz', 'Solar wind magnetic field bz')

if 'kp_index' in SWPC_COLLECTORS:
    kp_index = Gauge('kp_index', 'Planetary K-index (geomagnetic activity)')

if 'xray_flux' in SWPC_COLLECTORS:
    xray_flux_short = Gauge('xray_flux_short', 'GOES X-ray flux short wavelength (0.05-0.4 nm)')
    xray_flux_long = Gauge('xray_flux_long', 'GOES X-ray flux long wavelength (0.1-0.8 nm)')

if 'proton_flux' in SWPC_COLLECTORS:
    proton_flux_1mev = Gauge('proton_flux_1mev', 'GOES proton flux >= 1 MeV')
    proton_flux_5mev = Gauge('proton_flux_5mev', 'GOES proton flux >= 5 MeV')
    proton_flux_10mev = Gauge('proton_flux_10mev', 'GOES proton flux >= 10 MeV')
    proton_flux_30mev = Gauge('proton_flux_30mev', 'GOES proton flux >= 30 MeV')
    proton_flux_50mev = Gauge('proton_flux_50mev', 'GOES proton flux >= 50 MeV')
    proton_flux_60mev = Gauge('proton_flux_60mev', 'GOES proton flux >= 60 MeV')
    proton_flux_100mev = Gauge('proton_flux_100mev', 'GOES proton flux >= 100 MeV')
    proton_flux_500mev = Gauge('proton_flux_500mev', 'GOES proton flux >= 500 MeV')


start_http_server(SWPC_LISTEN_PORT)

logging.info('Started listening on 0.0.0.0:{}, scpaing interval: {} seconds'.format(SWPC_LISTEN_PORT, SWPC_MEASURE_INTERVAL))
logging.info('Collectors enabled: {}'.format(", ".join(SWPC_COLLECTORS)))

while True:
    if 'solar_wind_plasma' in SWPC_COLLECTORS:
        try:
            resp = requests.get(url=SWPC_SOLAR_WIND_PLASMA_URL)
            datum = resp.json()[-1]
            logging.info('Acquired solar wind plasma data (time: {}, speed: {}, density: {}, temp: {})'.format(datum[0], datum[2], datum[1], datum[3]))
        except Exception as e:
            logging.error('Error {} occured while getting data.'.format(e))
            datum = None

        if datum is not None:
            solar_wind_plasma_density.set(datum[1])
            solar_wind_plasma_speed.set(datum[2])
            solar_wind_plasma_temp.set(datum[3])

    if 'solar_wind_mag' in SWPC_COLLECTORS:
        try:
            resp = requests.get(url=SWPC_SOLAR_WIND_MAG_URL)
            datum = resp.json()[-1]
            logging.info('Acquired solar wind magnetic field data (time: {}, bx: {}, by: {}, bz: {})'.format(datum[0], datum[1], datum[2], datum[3]))
        except Exception as e:
            logging.error('Error {} occured while getting data.'.format(e))
            datum = None

        if datum is not None:
            solar_wind_mag_bx.set(datum[1])
            solar_wind_mag_by.set(datum[2])
            solar_wind_mag_bz.set(datum[3])

    if 'kp_index' in SWPC_COLLECTORS:
        try:
            resp = requests.get(url=SWPC_KP_INDEX_URL)
            data = resp.json()
            # Get the most recent Kp value (last entry, second column)
            datum = data[-1]
            kp_value = float(datum[1])
            logging.info('Acquired Kp index data (time: {}, Kp: {})'.format(datum[0], kp_value))
        except Exception as e:
            logging.error('Error {} occured while getting Kp index data.'.format(e))
            datum = None

        if datum is not None:
            kp_index.set(kp_value)

    if 'xray_flux' in SWPC_COLLECTORS:
        try:
            resp = requests.get(url=SWPC_XRAY_FLUX_URL)
            datum = resp.json()[-1]
            # datum format: [time_tag, satellite, flux, energy]
            # We need to separate short and long wavelength
            logging.info('Acquired X-ray flux data (time: {})'.format(datum['time_tag']))
            
            # Get latest data for both wavelengths
            data = resp.json()
            short_flux = None
            long_flux = None
            
            for entry in reversed(data):
                if entry['energy'] == '0.05-0.4nm' and short_flux is None:
                    short_flux = entry['flux']
                elif entry['energy'] == '0.1-0.8nm' and long_flux is None:
                    long_flux = entry['flux']
                if short_flux is not None and long_flux is not None:
                    break
                    
        except Exception as e:
            logging.error('Error {} occured while getting X-ray flux data.'.format(e))
            short_flux = None
            long_flux = None

        if short_flux is not None:
            xray_flux_short.set(short_flux)
        if long_flux is not None:
            xray_flux_long.set(long_flux)

    if 'proton_flux' in SWPC_COLLECTORS:
        try:
            resp = requests.get(url=SWPC_PROTON_FLUX_URL)
            data = resp.json()
            
            # Get the latest values for each energy threshold
            flux_values = {}
            for entry in reversed(data):
                energy = entry['energy']
                if energy not in flux_values:
                    flux_values[energy] = entry['flux']
                if len(flux_values) >= 8:  # We have 8 energy thresholds
                    break
            
            logging.info('Acquired proton flux data ({} energy levels)'.format(len(flux_values)))
            
        except Exception as e:
            logging.error('Error {} occured while getting proton flux data.'.format(e))
            flux_values = {}

        if flux_values:
            if '>=1 MeV' in flux_values:
                proton_flux_1mev.set(flux_values['>=1 MeV'])
            if '>=5 MeV' in flux_values:
                proton_flux_5mev.set(flux_values['>=5 MeV'])
            if '>=10 MeV' in flux_values:
                proton_flux_10mev.set(flux_values['>=10 MeV'])
            if '>=30 MeV' in flux_values:
                proton_flux_30mev.set(flux_values['>=30 MeV'])
            if '>=50 MeV' in flux_values:
                proton_flux_50mev.set(flux_values['>=50 MeV'])
            if '>=60 MeV' in flux_values:
                proton_flux_60mev.set(flux_values['>=60 MeV'])
            if '>=100 MeV' in flux_values:
                proton_flux_100mev.set(flux_values['>=100 MeV'])
            if '>=500 MeV' in flux_values:
                proton_flux_500mev.set(flux_values['>=500 MeV'])

    time.sleep(SWPC_MEASURE_INTERVAL)

