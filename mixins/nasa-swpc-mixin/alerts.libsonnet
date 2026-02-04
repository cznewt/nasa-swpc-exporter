{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'space-weather-solar-wind',
        rules: [
          {
            expr: |||
              solar_wind_plasma_speed{job=~"$job"} > 500
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Elevated solar wind speed detected',
              description: 'Solar wind speed is {{ $value | humanize }} km/s (threshold: 500 km/s). Minor geomagnetic activity possible.',
            },
            'for': '15m',
            alert: 'SolarWindSpeedElevated',
          },
          {
            expr: |||
              solar_wind_plasma_speed{job=~"$job"} > 750
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High solar wind speed detected',
              description: 'Solar wind speed is {{ $value | humanize }} km/s (threshold: 750 km/s). Significant geomagnetic storm possible.',
            },
            'for': '5m',
            alert: 'SolarWindSpeedHigh',
          },
          {
            expr: |||
              solar_wind_plasma_density{job=~"$job"} > 15
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Elevated solar wind density detected',
              description: 'Solar wind density is {{ $value | humanize }} particles/cm³ (threshold: 15). Possible CME or shock wave.',
            },
            'for': '15m',
            alert: 'SolarWindDensityElevated',
          },
          {
            expr: |||
              solar_wind_plasma_density{job=~"$job"} > 50
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Very high solar wind density detected',
              description: 'Solar wind density is {{ $value | humanize }} particles/cm³ (threshold: 50). Major CME or interplanetary shock likely.',
            },
            'for': '5m',
            alert: 'SolarWindDensityHigh',
          },
          {
            expr: |||
              solar_wind_mag_bz{job=~"$job"} < -10
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Southward IMF Bz component detected',
              description: 'IMF Bz is {{ $value | humanize }} nT (threshold: -10 nT). Enhanced geomagnetic activity expected.',
            },
            'for': '30m',
            alert: 'IMFBzSouthward',
          },
          {
            expr: |||
              solar_wind_mag_bz{job=~"$job"} < -20
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Strong southward IMF Bz component detected',
              description: 'IMF Bz is {{ $value | humanize }} nT (threshold: -20 nT). Major geomagnetic storm likely.',
            },
            'for': '15m',
            alert: 'IMFBzStronglySouthward',
          },
        ],
      },
      {
        name: 'space-weather-geomagnetic',
        rules: [
          {
            expr: |||
              kp_index{job=~"$job"} >= 5
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Geomagnetic storm (G1) in progress',
              description: 'Kp index is {{ $value }} (threshold: 5). Minor geomagnetic storm. Weak power grid fluctuations possible.',
            },
            'for': '15m',
            alert: 'GeomagneticStormG1',
          },
          {
            expr: |||
              kp_index{job=~"$job"} >= 6
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Geomagnetic storm (G2) in progress',
              description: 'Kp index is {{ $value }} (threshold: 6). Moderate geomagnetic storm. High-latitude power systems may experience voltage alarms.',
            },
            'for': '15m',
            alert: 'GeomagneticStormG2',
          },
          {
            expr: |||
              kp_index{job=~"$job"} >= 7
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Strong geomagnetic storm (G3) in progress',
              description: 'Kp index is {{ $value }} (threshold: 7). Strong geomagnetic storm. Power system voltage corrections required, satellite navigation degraded.',
            },
            'for': '10m',
            alert: 'GeomagneticStormG3',
          },
          {
            expr: |||
              kp_index{job=~"$job"} >= 8
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Severe geomagnetic storm (G4) in progress',
              description: 'Kp index is {{ $value }} (threshold: 8). Severe geomagnetic storm. Widespread power system problems, satellite navigation severely degraded.',
            },
            'for': '5m',
            alert: 'GeomagneticStormG4',
          },
          {
            expr: |||
              kp_index{job=~"$job"} >= 9
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Extreme geomagnetic storm (G5) in progress',
              description: 'Kp index is {{ $value }} (threshold: 9). EXTREME geomagnetic storm. Widespread power system collapse possible, complete satellite navigation outage.',
            },
            'for': '5m',
            alert: 'GeomagneticStormG5',
          },
        ],
      },
      {
        name: 'space-weather-solar-radiation',
        rules: [
          {
            expr: |||
              xray_flux_long{job=~"$job"} >= 1e-5
            ||| % $._config,
            labels: {
              severity: 'info',
            },
            annotations: {
              summary: 'M-class solar flare detected',
              description: 'X-ray flux (0.1-0.8nm) is {{ $value }} W/m² (threshold: 1e-5). M-class flare in progress. Minor radio blackouts possible.',
            },
            'for': '5m',
            alert: 'SolarFlareM',
          },
          {
            expr: |||
              xray_flux_long{job=~"$job"} >= 1e-4
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'X-class solar flare detected',
              description: 'X-ray flux (0.1-0.8nm) is {{ $value }} W/m² (threshold: 1e-4). X-class flare in progress. HF radio blackouts on sunlit side of Earth.',
            },
            'for': '5m',
            alert: 'SolarFlareX',
          },
          {
            expr: |||
              proton_flux_10mev{job=~"$job"} >= 10
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Solar radiation storm (S1) detected',
              description: 'Proton flux (≥10 MeV) is {{ $value }} pfu (threshold: 10). Minor radiation storm. Minor impacts on HF radio and satellite operations.',
            },
            'for': '15m',
            alert: 'SolarRadiationStormS1',
          },
          {
            expr: |||
              proton_flux_10mev{job=~"$job"} >= 100
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Solar radiation storm (S2) detected',
              description: 'Proton flux (≥10 MeV) is {{ $value }} pfu (threshold: 100). Moderate radiation storm. Small effects on HF radio propagation, increased radiation risk for astronauts.',
            },
            'for': '15m',
            alert: 'SolarRadiationStormS2',
          },
          {
            expr: |||
              proton_flux_10mev{job=~"$job"} >= 1000
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Solar radiation storm (S3) detected',
              description: 'Proton flux (≥10 MeV) is {{ $value }} pfu (threshold: 1000). Strong radiation storm. Wide area HF radio blackout, radiation hazard to astronauts on EVA.',
            },
            'for': '10m',
            alert: 'SolarRadiationStormS3',
          },
          {
            expr: |||
              proton_flux_10mev{job=~"$job"} >= 10000
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Solar radiation storm (S4) detected',
              description: 'Proton flux (≥10 MeV) is {{ $value }} pfu (threshold: 10000). Severe radiation storm. HF radio blackout on entire sunlit side, increased radiation risk to astronauts.',
            },
            'for': '5m',
            alert: 'SolarRadiationStormS4',
          },
          {
            expr: |||
              proton_flux_10mev{job=~"$job"} >= 100000
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Solar radiation storm (S5) detected',
              description: 'Proton flux (≥10 MeV) is {{ $value }} pfu (threshold: 100000). EXTREME radiation storm. Complete HF radio blackout, high radiation risk, satellite operations severely impacted.',
            },
            'for': '5m',
            alert: 'SolarRadiationStormS5',
          },
          {
            expr: |||
              proton_flux_100mev{job=~"$job"} >= 1
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High-energy proton event detected',
              description: 'Proton flux (≥100 MeV) is {{ $value }} pfu (threshold: 1). High-energy protons detected. Increased radiation risk for high-altitude flights and spacecraft.',
            },
            'for': '15m',
            alert: 'HighEnergyProtonEvent',
          },
        ],
      },
      {
        name: 'space-weather-data-quality',
        rules: [
          {
            expr: |||
              absent(solar_wind_plasma_speed{job=~"$job"})
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Solar wind plasma data missing',
              description: 'No solar wind plasma data received for 5 minutes. Check exporter status.',
            },
            'for': '5m',
            alert: 'SolarWindPlasmaDataMissing',
          },
          {
            expr: |||
              absent(kp_index{job=~"$job"})
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Kp index data missing',
              description: 'No Kp index data received for 5 minutes. Check exporter status.',
            },
            'for': '5m',
            alert: 'KpIndexDataMissing',
          },
          {
            expr: |||
              absent(xray_flux_long{job=~"$job"})
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'X-ray flux data missing',
              description: 'No X-ray flux data received for 5 minutes. Check exporter status.',
            },
            'for': '5m',
            alert: 'XrayFluxDataMissing',
          },
        ],
      },
    ],
  },
}
