local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  grafanaDashboards+:: {
    'solar-wind.json':
      local datasourceVariable =
        g.dashboard.variable.datasource.new('datasource', 'prometheus')
        + g.dashboard.variable.datasource.generalOptions.withLabel('Data source');

      g.dashboard.new('Space Weather (NOAA SWPC)')
      + g.dashboard.withDescription('Real-time space weather data from NASA NOAA Space Weather Prediction Center')
      + g.dashboard.withTags(['nasa-swpc-mixin', 'space-weather'])
      + g.dashboard.withUid('nasa-swpc-space-weather')
      + g.dashboard.withRefresh('1m')
      + g.dashboard.time.withFrom('now-6h')
      + g.dashboard.time.withTo('now')
      + g.dashboard.withVariables([
        datasourceVariable,
      ])
      + g.dashboard.withPanels(
        g.util.grid.makeGrid([
          // Row 1: Solar Wind Plasma
          g.panel.row.new('Solar Wind Plasma'),

          g.panel.stat.new('Solar Wind Speed')
          + g.panel.stat.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_plasma_speed'
            )
            + g.query.prometheus.withLegendFormat('Speed'),
          ])
          + g.panel.stat.options.withGraphMode('area')
          + g.panel.stat.options.withColorMode('value')
          + g.panel.stat.standardOptions.withUnit('velocitykmh')
          + g.panel.stat.standardOptions.withDecimals(0),

          g.panel.stat.new('Plasma Density')
          + g.panel.stat.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_plasma_density'
            )
            + g.query.prometheus.withLegendFormat('Density'),
          ])
          + g.panel.stat.options.withGraphMode('area')
          + g.panel.stat.options.withColorMode('value')
          + g.panel.stat.standardOptions.withUnit('short')
          + g.panel.stat.standardOptions.withDecimals(1),

          g.panel.stat.new('Plasma Temperature')
          + g.panel.stat.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_plasma_temperature'
            )
            + g.query.prometheus.withLegendFormat('Temperature'),
          ])
          + g.panel.stat.options.withGraphMode('area')
          + g.panel.stat.options.withColorMode('value')
          + g.panel.stat.standardOptions.withUnit('kelvin')
          + g.panel.stat.standardOptions.withDecimals(0),

          g.panel.timeSeries.new('Solar Wind Speed History')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_plasma_speed'
            )
            + g.query.prometheus.withLegendFormat('Speed (km/s)'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('velocitykmh')
          + g.panel.timeSeries.standardOptions.withMin(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

          g.panel.timeSeries.new('Plasma Density History')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_plasma_density'
            )
            + g.query.prometheus.withLegendFormat('Density (cm⁻³)'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('short')
          + g.panel.timeSeries.standardOptions.withMin(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

          g.panel.timeSeries.new('Plasma Temperature History')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_plasma_temperature'
            )
            + g.query.prometheus.withLegendFormat('Temperature (K)'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('kelvin')
          + g.panel.timeSeries.standardOptions.withMin(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

          // Row 2: Solar Wind Magnetic Field
          g.panel.row.new('Solar Wind Magnetic Field'),

          g.panel.timeSeries.new('Magnetic Field Components')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_mag_bx'
            )
            + g.query.prometheus.withLegendFormat('Bx (nT)'),
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_mag_by'
            )
            + g.query.prometheus.withLegendFormat('By (nT)'),
            g.query.prometheus.new(
              '${datasource}',
              'solar_wind_mag_bz'
            )
            + g.query.prometheus.withLegendFormat('Bz (nT)'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('short')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

          // Row 3: Geomagnetic Activity
          g.panel.row.new('Geomagnetic Activity'),

          g.panel.stat.new('Kp Index')
          + g.panel.stat.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'kp_index'
            )
            + g.query.prometheus.withLegendFormat('Kp'),
          ])
          + g.panel.stat.options.withGraphMode('area')
          + g.panel.stat.options.withColorMode('value')
          + g.panel.stat.standardOptions.withUnit('short')
          + g.panel.stat.standardOptions.withMin(0)
          + g.panel.stat.standardOptions.withMax(9)
          + g.panel.stat.standardOptions.withDecimals(1)
          + g.panel.stat.standardOptions.thresholds.withMode('absolute')
          + g.panel.stat.standardOptions.thresholds.withSteps([
            { value: null, color: 'green' },
            { value: 4, color: 'yellow' },
            { value: 5, color: 'orange' },
            { value: 7, color: 'red' },
          ]),

          g.panel.timeSeries.new('Kp Index History')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'kp_index'
            )
            + g.query.prometheus.withLegendFormat('Kp Index'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('short')
          + g.panel.timeSeries.standardOptions.withMin(0)
          + g.panel.timeSeries.standardOptions.withMax(9)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never'),

          // Row 4: Solar X-ray Flux
          g.panel.row.new('Solar X-ray Flux'),

          g.panel.timeSeries.new('X-ray Flux')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'xray_flux_short'
            )
            + g.query.prometheus.withLegendFormat('Short (0.05-0.4 nm)'),
            g.query.prometheus.new(
              '${datasource}',
              'xray_flux_long'
            )
            + g.query.prometheus.withLegendFormat('Long (0.1-0.8 nm)'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('watt/m²')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('W/m²')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withType('log')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withLog(10),

          // Row 5: Proton Flux
          g.panel.row.new('GOES Proton Flux'),

          g.panel.timeSeries.new('Proton Flux (Low Energy)')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_1mev'
            )
            + g.query.prometheus.withLegendFormat('≥1 MeV'),
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_5mev'
            )
            + g.query.prometheus.withLegendFormat('≥5 MeV'),
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_10mev'
            )
            + g.query.prometheus.withLegendFormat('≥10 MeV'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('short')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('particles/cm²/s/sr')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withType('log')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withLog(10),

          g.panel.timeSeries.new('Proton Flux (Medium Energy)')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_30mev'
            )
            + g.query.prometheus.withLegendFormat('≥30 MeV'),
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_50mev'
            )
            + g.query.prometheus.withLegendFormat('≥50 MeV'),
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_60mev'
            )
            + g.query.prometheus.withLegendFormat('≥60 MeV'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('short')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('particles/cm²/s/sr')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withType('log')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withLog(10),

          g.panel.timeSeries.new('Proton Flux (High Energy)')
          + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_100mev'
            )
            + g.query.prometheus.withLegendFormat('≥100 MeV'),
            g.query.prometheus.new(
              '${datasource}',
              'proton_flux_500mev'
            )
            + g.query.prometheus.withLegendFormat('≥500 MeV'),
          ])
          + g.panel.timeSeries.standardOptions.withUnit('short')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('particles/cm²/s/sr')
          + g.panel.timeSeries.fieldConfig.defaults.custom.withLineWidth(2)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
          + g.panel.timeSeries.fieldConfig.defaults.custom.withShowPoints('never')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withType('log')
          + g.panel.timeSeries.fieldConfig.defaults.custom.scaleDistribution.withLog(10),
        ], panelWidth=8, panelHeight=8)
      ),
  },
}
