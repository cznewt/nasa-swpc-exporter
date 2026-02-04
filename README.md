# NASA NOAA SWPC Exporter

Simple Prometheus exporter for current space-weather data collected from NASA NOAA
Space Weather Prediction Center.

## Implemented collectors

* Plasma - Solar Wind Electron Proton Alpha Monitor (SWEPAM)

## Configuration

The exporter can be configured using the following environment variables:

| Variable | Description | Default |
| :--- | :--- | :--- |
| `SWPC_MEASURE_INTERVAL` | Interval between data scrapes in seconds. | `60` |
| `SWPC_LISTEN_PORT` | Port where the metrics are exposed. | `9468` |
| `SWPC_COLLECTORS` | Comma-separated list of enabled collectors. Options: `solar_wind_plasma`, `solar_wind_mag`. | `solar_wind_plasma,solar_wind_mag` |

## Data Sources

Data is scraped from the NASA NOAA Space Weather Prediction Center (SWPC) Real-time Solar Wind services.

- **Plasma**: `http://services.swpc.noaa.gov/products/solar-wind/plasma-1-day.json`
- **Magnetometer**: `http://services.swpc.noaa.gov/products/solar-wind/mag-1-day.json`

## Telemetry (Metrics)

The exporter exposes the following Prometheus metrics:

### Plasma Collector (`solar_wind_plasma`)

- `solar_wind_plasma_density`: Solar wind plasma particle density (cm^-3).
- `solar_wind_plasma_speed`: Solar wind plasma speed (km/s).
- `solar_wind_plasma_temperature`: Solar wind plasma temperature (K).

### Magnetometer Collector (`solar_wind_mag`)

- `solar_wind_mag_bx`: Solar wind magnetic field Bx component (nT).
- `solar_wind_mag_by`: Solar wind magnetic field By component (nT).
- `solar_wind_mag_bz`: Solar wind magnetic field Bz component (nT).

## References

* https://www.swpc.noaa.gov/products/real-time-solar-wind
* https://en.wikipedia.org/wiki/Solar_wind