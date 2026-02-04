# NASA NOAA SWPC Exporter

Simple Prometheus exporter for current space-weather data collected from NASA NOAA
Space Weather Prediction Center.

## Implemented collectors

* **Plasma** - Solar Wind Electron Proton Alpha Monitor (SWEPAM)
* **Magnetometer** - Solar Wind Magnetic Field
* **Kp Index** - Planetary K-index (Geomagnetic Activity)
* **X-ray Flux** - GOES Solar X-ray Flux
* **Proton Flux** - GOES Integral Proton Flux

## Configuration

The exporter can be configured using the following environment variables:

| Variable | Description | Default |
| :--- | :--- | :--- |
| `SWPC_MEASURE_INTERVAL` | Interval between data scrapes in seconds. | `60` |
| `SWPC_LISTEN_PORT` | Port where the metrics are exposed. | `9468` |
| `SWPC_COLLECTORS` | Comma-separated list of enabled collectors. Options: `solar_wind_plasma`, `solar_wind_mag`, `kp_index`, `xray_flux`, `proton_flux`. | `solar_wind_plasma,solar_wind_mag,kp_index,xray_flux,proton_flux` |

## Data Sources

Data is scraped from the NASA NOAA Space Weather Prediction Center (SWPC) Real-time Solar Wind services.

- **Plasma**: `http://services.swpc.noaa.gov/products/solar-wind/plasma-1-day.json`
- **Magnetometer**: `http://services.swpc.noaa.gov/products/solar-wind/mag-1-day.json`
- **Kp Index**: `https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json`
- **X-ray Flux**: `https://services.swpc.noaa.gov/json/goes/primary/xrays-1-day.json`
- **Proton Flux**: `https://services.swpc.noaa.gov/json/goes/primary/integral-protons-1-day.json`

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

### Kp Index Collector (`kp_index`)

- `kp_index`: Planetary K-index (0-9 scale) indicating geomagnetic activity level.

### X-ray Flux Collector (`xray_flux`)

- `xray_flux_short`: GOES X-ray flux short wavelength 0.05-0.4 nm (W/m²).
- `xray_flux_long`: GOES X-ray flux long wavelength 0.1-0.8 nm (W/m²).

### Proton Flux Collector (`proton_flux`)

- `proton_flux_1mev`: GOES integral proton flux ≥1 MeV (particles/cm²/s/sr).
- `proton_flux_5mev`: GOES integral proton flux ≥5 MeV (particles/cm²/s/sr).
- `proton_flux_10mev`: GOES integral proton flux ≥10 MeV (particles/cm²/s/sr).
- `proton_flux_30mev`: GOES integral proton flux ≥30 MeV (particles/cm²/s/sr).
- `proton_flux_50mev`: GOES integral proton flux ≥50 MeV (particles/cm²/s/sr).
- `proton_flux_60mev`: GOES integral proton flux ≥60 MeV (particles/cm²/s/sr).
- `proton_flux_100mev`: GOES integral proton flux ≥100 MeV (particles/cm²/s/sr).
- `proton_flux_500mev`: GOES integral proton flux ≥500 MeV (particles/cm²/s/sr).


## References

* https://www.swpc.noaa.gov/products/real-time-solar-wind
* https://en.wikipedia.org/wiki/Solar_wind