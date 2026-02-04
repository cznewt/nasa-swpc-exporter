
# Alerts

Prometheus alerting rules for space weather monitoring based on NASA NOAA SWPC data.

## Alert Groups

### Solar Wind Alerts

Alerts related to solar wind plasma and magnetic field conditions.

#### SolarWindSpeedElevated

- **Severity**: Warning
- **Threshold**: Solar wind speed > 500 km/s
- **Duration**: 15 minutes
- **Impact**: Minor geomagnetic activity possible
- **Description**: Elevated solar wind speed detected. This may precede geomagnetic disturbances.

#### SolarWindSpeedHigh

- **Severity**: Critical
- **Threshold**: Solar wind speed > 750 km/s
- **Duration**: 5 minutes
- **Impact**: Significant geomagnetic storm possible
- **Description**: Very high solar wind speed detected. Major geomagnetic activity expected.

#### SolarWindDensityElevated

- **Severity**: Warning
- **Threshold**: Solar wind density > 15 particles/cm³
- **Duration**: 15 minutes
- **Impact**: Possible CME or shock wave
- **Description**: Elevated solar wind density may indicate a coronal mass ejection (CME) or interplanetary shock.

#### SolarWindDensityHigh

- **Severity**: Critical
- **Threshold**: Solar wind density > 50 particles/cm³
- **Duration**: 5 minutes
- **Impact**: Major CME or interplanetary shock likely
- **Description**: Very high density indicates a strong CME or shock wave approaching Earth.

#### IMFBzSouthward

- **Severity**: Warning
- **Threshold**: IMF Bz < -10 nT
- **Duration**: 30 minutes
- **Impact**: Enhanced geomagnetic activity expected
- **Description**: Southward interplanetary magnetic field (IMF) Bz component detected. When combined with high solar wind speed, this can trigger geomagnetic storms.

#### IMFBzStronglySouthward

- **Severity**: Critical
- **Threshold**: IMF Bz < -20 nT
- **Duration**: 15 minutes
- **Impact**: Major geomagnetic storm likely
- **Description**: Strong southward IMF Bz component. High probability of major geomagnetic storm.

---

### Geomagnetic Storm Alerts

Alerts based on the Kp index following the NOAA G-scale for geomagnetic storms.

#### GeomagneticStormG1

- **Severity**: Warning
- **Threshold**: Kp index ≥ 5
- **Duration**: 15 minutes
- **NOAA Scale**: G1 (Minor)
- **Impacts**:
  - Weak power grid fluctuations
  - Minor impact on satellite operations
  - Aurora visible at high latitudes (60° geomagnetic latitude)

#### GeomagneticStormG2

- **Severity**: Warning
- **Threshold**: Kp index ≥ 6
- **Duration**: 15 minutes
- **NOAA Scale**: G2 (Moderate)
- **Impacts**:
  - High-latitude power systems may experience voltage alarms
  - Spacecraft charging may occur
  - Aurora visible at mid-latitudes (55° geomagnetic latitude)

#### GeomagneticStormG3

- **Severity**: Critical
- **Threshold**: Kp index ≥ 7
- **Duration**: 10 minutes
- **NOAA Scale**: G3 (Strong)
- **Impacts**:
  - Power system voltage corrections required
  - Satellite surface charging and orientation problems
  - Intermittent satellite navigation problems
  - Aurora visible at lower mid-latitudes (50° geomagnetic latitude)

#### GeomagneticStormG4

- **Severity**: Critical
- **Threshold**: Kp index ≥ 8
- **Duration**: 5 minutes
- **NOAA Scale**: G4 (Severe)
- **Impacts**:
  - Widespread power system voltage control problems
  - Satellite surface charging and tracking problems
  - Satellite navigation degraded for hours
  - Aurora visible at mid-latitudes (45° geomagnetic latitude)

#### GeomagneticStormG5

- **Severity**: Critical
- **Threshold**: Kp index ≥ 9
- **Duration**: 5 minutes
- **NOAA Scale**: G5 (Extreme)
- **Impacts**:
  - Widespread power system collapse or blackouts possible
  - Extensive satellite surface charging, orientation problems
  - Satellite navigation may be unavailable for days
  - Aurora visible at low latitudes (40° geomagnetic latitude)

---

### Solar Radiation Alerts

Alerts for solar flares and solar radiation storms.

#### SolarFlareM

- **Severity**: Info
- **Threshold**: X-ray flux (0.1-0.8 nm) ≥ 1e-5 W/m²
- **Duration**: 5 minutes
- **Flare Class**: M-class
- **Impacts**:
  - Minor radio blackouts on sunlit side of Earth
  - Small radiation storm possible

#### SolarFlareX

- **Severity**: Warning
- **Threshold**: X-ray flux (0.1-0.8 nm) ≥ 1e-4 W/m²
- **Duration**: 5 minutes
- **Flare Class**: X-class
- **Impacts**:
  - Wide-area HF radio blackouts on sunlit side of Earth
  - Radiation storm likely
  - Satellite navigation degradation

#### SolarRadiationStormS1

- **Severity**: Warning
- **Threshold**: Proton flux (≥10 MeV) ≥ 10 pfu
- **Duration**: 15 minutes
- **NOAA Scale**: S1 (Minor)
- **Impacts**:
  - Minor impacts on HF radio in polar regions
  - Small effects on satellite operations

#### SolarRadiationStormS2

- **Severity**: Warning
- **Threshold**: Proton flux (≥10 MeV) ≥ 100 pfu
- **Duration**: 15 minutes
- **NOAA Scale**: S2 (Moderate)
- **Impacts**:
  - Small effects on HF radio propagation through polar regions
  - Increased radiation risk for astronauts on EVA
  - Passengers and crew in high-latitude, high-altitude flights at small increased radiation risk

#### SolarRadiationStormS3

- **Severity**: Critical
- **Threshold**: Proton flux (≥10 MeV) ≥ 1,000 pfu
- **Duration**: 10 minutes
- **NOAA Scale**: S3 (Strong)
- **Impacts**:
  - Wide area HF radio blackout in polar regions
  - Radiation hazard to astronauts on EVA
  - High-altitude flights at high latitudes may need to be rerouted

#### SolarRadiationStormS4

- **Severity**: Critical
- **Threshold**: Proton flux (≥10 MeV) ≥ 10,000 pfu
- **Duration**: 5 minutes
- **NOAA Scale**: S4 (Severe)
- **Impacts**:
  - HF radio blackout on entire sunlit side of Earth
  - Increased radiation risk to astronauts on EVA (high risk)
  - High-altitude flights at high latitudes must be avoided

#### SolarRadiationStormS5

- **Severity**: Critical
- **Threshold**: Proton flux (≥10 MeV) ≥ 100,000 pfu
- **Duration**: 5 minutes
- **NOAA Scale**: S5 (Extreme)
- **Impacts**:
  - Complete HF radio blackout on entire sunlit side of Earth
  - Unavoidable high radiation risk to astronauts on EVA
  - High-altitude flights prohibited
  - Satellite operations severely impacted

#### HighEnergyProtonEvent

- **Severity**: Warning
- **Threshold**: Proton flux (≥100 MeV) ≥ 1 pfu
- **Duration**: 15 minutes
- **Impacts**:
  - Increased radiation risk for high-altitude flights
  - Potential spacecraft single-event upsets
  - Increased radiation dose for astronauts

---

### Data Quality Alerts

Alerts for monitoring the exporter's data collection health.

#### SolarWindPlasmaDataMissing

- **Severity**: Warning
- **Threshold**: No data received for 5 minutes
- **Action**: Check exporter status and NOAA SWPC API availability

#### KpIndexDataMissing

- **Severity**: Warning
- **Threshold**: No data received for 5 minutes
- **Action**: Check exporter status and NOAA SWPC API availability

#### XrayFluxDataMissing

- **Severity**: Warning
- **Threshold**: No data received for 5 minutes
- **Action**: Check exporter status and NOAA SWPC API availability

---

## Alert Configuration

Alerts are defined in the mixin at `mixins/nasa-swpc-mixin/alerts.libsonnet`.

To customize alert thresholds or add new alerts, modify the alerts file and regenerate the Prometheus rules:

```bash
make prometheus_alerts.yaml
```

## References

- [NOAA Space Weather Scales](https://www.swpc.noaa.gov/noaa-scales-explanation)
- [NOAA SWPC Products](https://www.swpc.noaa.gov/products-and-data)
- [Space Weather Impacts](https://www.swpc.noaa.gov/impacts)
