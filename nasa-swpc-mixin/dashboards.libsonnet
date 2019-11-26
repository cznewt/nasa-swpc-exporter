local grafana = import 'vendor/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;
local template = grafana.template;
local prometheus_ds = 'default';

{
  grafanaDashboards+:: {
    'solar-wind.json':
      dashboard.new(
        'Solar Wind (NOAA DSCOVR)',
        refresh='1m',
        editable=true,
        tags=['nasa-swpc-mixin'],
      )
      .addTemplate(
        grafana.template.datasource(
          'PROMETHEUS_DS',
          'prometheus',
          prometheus_ds,
          label='Data Source',
        )
      )
      .addPanel(
        singlestat.new(
          'Current Solar Wind Speed',
          datasource='-- Mixed --',
          valueName='current',
          postfix=' km/s',
        )
        .addTarget(
          prometheus.target(
            'solar_wind_speed',
            datasource='$PROMETHEUS_DS',
          )
        ),
        { w: 6, h: 5, x: 0, y: 0 }
      )
      .addPanel(
        graphPanel.new(
          'Solar Wind Speed History',
          fill=5,
          min=0,
          format='short',
          linewidth=2,
          datasource='-- Mixed --',
        )
        .addTarget(
          prometheus.target(
            'solar_wind_speed',
            datasource='$PROMETHEUS_DS',
            legendFormat='solar wind speed',
          )
        ),
        { w: 18, h: 5, x: 6, y: 0 }
      )
      .addPanel(
        singlestat.new(
          'Current Solar Wind Density',
          datasource='-- Mixed --',
          valueName='current',
          postfix=' atoms/cm&sup3;',
        )
        .addTarget(
          prometheus.target(
            'solar_wind_density',
            datasource='$PROMETHEUS_DS',
          )
        ),
        { w: 6, h: 5, x: 0, y: 5 }
      )
      .addPanel(
        graphPanel.new(
          'Solar Wind Density History',
          fill=5,
          min=0,
          format='short',
          linewidth=2,
          datasource='-- Mixed --',
        )
        .addTarget(
          prometheus.target(
            'solar_wind_density',
            datasource='$PROMETHEUS_DS',
            legendFormat='solar wind density',
          )
        )
        .addSeriesOverride(
          { alias: 'solar wind density', color: '#5195CE' },
        ),
        { w: 18, h: 5, x: 6, y: 5 }
      )
      .addPanel(
        singlestat.new(
          'Current Solar Wind Temperature',
          datasource='-- Mixed --',
          valueName='current',
          postfix=' K',
        )
        .addTarget(
          prometheus.target(
            'solar_wind_temperature',
            datasource='$PROMETHEUS_DS',
          )
        ),
        { w: 6, h: 5, x: 0, y: 10 }
      )
      .addPanel(
        graphPanel.new(
          'Solar Wind Temperature History',
          fill=5,
          min=0,
          format='short',
          linewidth=2,
          datasource='-- Mixed --',
        )
        .addTarget(
          prometheus.target(
            'solar_wind_temperature',
            datasource='$PROMETHEUS_DS',
            legendFormat='solar wind temperature',
          )
        )
        .addSeriesOverride(
          { alias: 'solar wind temperature', color: '#D683CE' },
        ),
        { w: 18, h: 5, x: 6, y: 10 }
      )
  }
}
