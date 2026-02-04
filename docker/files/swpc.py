
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

SWPC_MEASURE_INTERVAL = int(os.getenv('SWPC_MEASURE_INTERVAL', 60))
SWPC_LISTEN_PORT =  int(os.getenv('SWPC_LISTEN_PORT', 9468))
SWPC_COLLECTORS =  os.getenv('SWPC_COLLECTORS', 'solar_wind_plasma,solar_wind_mag').split(',')

if 'solar_wind_plasma' in SWPC_COLLECTORS:
    solar_wind_plasma_density = Gauge('solar_wind_plasma_density', 'Solar wind plasma particle density')
    solar_wind_plasma_speed = Gauge('solar_wind_plasma_speed', 'Solar wind plasma speed')
    solar_wind_plasma_temp = Gauge('solar_wind_plasma_temperature', 'Solar wind plasma temperature')

if 'solar_wind_mag' in SWPC_COLLECTORS:
    solar_wind_mag_bx = Gauge('solar_wind_mag_bx', 'Solar wind magnetic field bx')
    solar_wind_mag_by = Gauge('solar_wind_mag_by', 'Solar wind magnetic field by')
    solar_wind_mag_bz = Gauge('solar_wind_mag_bz', 'Solar wind magnetic field bz')

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

    time.sleep(SWPC_MEASURE_INTERVAL)
