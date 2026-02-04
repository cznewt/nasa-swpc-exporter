
# Telemetry

Exposed telemetry data from the NASA NOAA SWPC Exporter.

## Metrics

### Solar Wind Plasma Metrics

| Name | Type | Unit | Labels | Description |
| :--- | :--- | :--- | :--- | :--- |
| `solar_wind_plasma_density` | Gauge | particles/cm³ | - | Solar wind plasma particle density from SWEPAM instrument. |
| `solar_wind_plasma_speed` | Gauge | km/s | - | Solar wind plasma bulk velocity. |
| `solar_wind_plasma_temperature` | Gauge | K | - | Solar wind plasma temperature. |

**Data Source**: [NOAA SWPC Solar Wind Plasma](http://services.swpc.noaa.gov/products/solar-wind/plasma-1-day.json)

### Solar Wind Magnetic Field Metrics

| Name | Type | Unit | Labels | Description |
| :--- | :--- | :--- | :--- | :--- |
| `solar_wind_mag_bx` | Gauge | nT | - | Solar wind magnetic field Bx component (GSM coordinates). |
| `solar_wind_mag_by` | Gauge | nT | - | Solar wind magnetic field By component (GSM coordinates). |
| `solar_wind_mag_bz` | Gauge | nT | - | Solar wind magnetic field Bz component (GSM coordinates). |

**Data Source**: [NOAA SWPC Solar Wind Magnetometer](http://services.swpc.noaa.gov/products/solar-wind/mag-1-day.json)

**Note**: The Bz component is particularly important for space weather forecasting. Southward Bz (negative values) can trigger geomagnetic storms when combined with high solar wind speed.

### Geomagnetic Activity Metrics

| Name | Type | Unit | Labels | Description |
| :--- | :--- | :--- | :--- | :--- |
| `kp_index` | Gauge | index (0-9) | - | Planetary K-index indicating global geomagnetic activity level. |

**Data Source**: [NOAA Planetary K-index](https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json)

**Kp Index Scale**:
- **0-2**: Quiet conditions
- **3**: Unsettled
- **4**: Active
- **5**: Minor storm (G1)
- **6**: Moderate storm (G2)
- **7**: Strong storm (G3)
- **8**: Severe storm (G4)
- **9**: Extreme storm (G5)

### Solar X-ray Flux Metrics

| Name | Type | Unit | Labels | Description |
| :--- | :--- | :--- | :--- | :--- |
| `xray_flux_short` | Gauge | W/m² | - | GOES X-ray flux in short wavelength band (0.05-0.4 nm). |
| `xray_flux_long` | Gauge | W/m² | - | GOES X-ray flux in long wavelength band (0.1-0.8 nm). |

**Data Source**: [GOES X-ray Flux](https://services.swpc.noaa.gov/json/goes/primary/xrays-1-day.json)

**Solar Flare Classification** (based on long wavelength):
- **A-class**: < 1e-7 W/m²
- **B-class**: 1e-7 to 1e-6 W/m²
- **C-class**: 1e-6 to 1e-5 W/m²
- **M-class**: 1e-5 to 1e-4 W/m² (Minor radio blackouts)
- **X-class**: ≥ 1e-4 W/m² (Major radio blackouts)

### GOES Proton Flux Metrics

| Name | Type | Unit | Labels | Description |
| :--- | :--- | :--- | :--- | :--- |
| `proton_flux_1mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥1 MeV. |
| `proton_flux_5mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥5 MeV. |
| `proton_flux_10mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥10 MeV. |
| `proton_flux_30mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥30 MeV. |
| `proton_flux_50mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥50 MeV. |
| `proton_flux_60mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥60 MeV. |
| `proton_flux_100mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥100 MeV. |
| `proton_flux_500mev` | Gauge | particles/cm²/s/sr | - | Integral proton flux for energies ≥500 MeV. |

**Data Source**: [GOES Integral Proton Flux](https://services.swpc.noaa.gov/json/goes/primary/integral-protons-1-day.json)

**Solar Radiation Storm Scale** (based on ≥10 MeV protons):
- **S1 (Minor)**: ≥10 pfu
- **S2 (Moderate)**: ≥100 pfu
- **S3 (Strong)**: ≥1,000 pfu
- **S4 (Severe)**: ≥10,000 pfu
- **S5 (Extreme)**: ≥100,000 pfu

*pfu = particle flux unit (particles/cm²/s/sr)*

## Metric Collection

All metrics are collected at the interval specified by `SWPC_MEASURE_INTERVAL` (default: 60 seconds).

Individual collectors can be enabled/disabled via the `SWPC_COLLECTORS` environment variable.

## Logs

Standard Python log format with the following levels:
- **INFO**: Normal operation, data acquisition confirmations
- **ERROR**: Data retrieval failures, API errors

Log format: `%(asctime)s [%(levelname)-5.5s]  %(message)s`
