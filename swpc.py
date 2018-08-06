
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

SWPC_SOLAR_WIND_URL = 'http://services.swpc.noaa.gov/products/solar-wind/plasma-1-day.json'
SWPC_MEASURE_INTERVAL = int(os.getenv('SWPC_MEASURE_INTERVAL', 60))
SWPC_LISTEN_PORT =  int(os.getenv('SWPC_LISTEN_PORT', 9468))

wind_density = Gauge('solar_wind_density', 'Solar wind particle density')
wind_speed = Gauge('solar_wind_speed', 'Solar wind speed')
wind_temp = Gauge('solar_wind_temperature', 'Solar wind temperature')

start_http_server(SWPC_LISTEN_PORT)
logging.info('Started listening on 0.0.0.0:{}'.format(SWPC_LISTEN_PORT))


while True:
    try:
        resp = requests.get(url=SWPC_SOLAR_WIND_URL)
        datum = resp.json()[-1]
        logging.info('Acquired data (time: {}, speed: {}, density: {})'.format(datum[0], datum[2], datum[1]))
    except Exception as e:
        logging.error('Error {} occured while getting data.'.format(e))
        datum = None

    if datum is not None:
        wind_density.set(datum[1])
        wind_speed.set(datum[2])
        wind_temp.set(datum[3])

    time.sleep(SWPC_MEASURE_INTERVAL)
