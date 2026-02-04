# NASA SWPC Exporter Helm Chart

A Helm chart for deploying the NASA NOAA SWPC (Space Weather Prediction Center) Prometheus exporter on Kubernetes.

## Overview

This chart deploys the nasa-swpc-exporter, which collects real-time space weather data from NASA NOAA SWPC and exposes it as Prometheus metrics.

## Installation

### Add the repository (if published)

```bash
helm repo add nasa-swpc-exporter https://your-repo-url
helm repo update
```

### Install from local chart

```bash
helm install nasa-swpc-exporter ./nasa-swpc-exporter-chart
```

### Install with custom values

```bash
helm install nasa-swpc-exporter ./nasa-swpc-exporter-chart -f custom-values.yaml
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

### General Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `ghcr.io/cznewt/nasa-swpc-exporter` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag | `latest` |
| `nameOverride` | Override chart name | `""` |
| `fullnameOverride` | Override full name | `""` |

### Service Account

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |

### Security

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podSecurityContext.runAsNonRoot` | Run as non-root user | `true` |
| `podSecurityContext.runAsUser` | User ID | `65534` |
| `podSecurityContext.fsGroup` | Filesystem group | `65534` |
| `securityContext.allowPrivilegeEscalation` | Allow privilege escalation | `false` |
| `securityContext.readOnlyRootFilesystem` | Read-only root filesystem | `true` |

### Service

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `9468` |
| `service.targetPort` | Target port | `9468` |
| `service.annotations` | Service annotations | `{}` |

### Resources

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.limits.cpu` | CPU limit | `100m` |
| `resources.limits.memory` | Memory limit | `128Mi` |
| `resources.requests.cpu` | CPU request | `50m` |
| `resources.requests.memory` | Memory request | `64Mi` |

### Exporter Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.measureInterval` | Data scrape interval (seconds) | `60` |
| `config.listenPort` | Metrics port | `9468` |
| `config.collectors` | Enabled collectors (comma-separated) | `solar_wind_plasma,solar_wind_mag,kp_index,xray_flux,proton_flux` |

Available collectors:
- `solar_wind_plasma` - Solar wind plasma data (speed, density, temperature)
- `solar_wind_mag` - Solar wind magnetic field (Bx, By, Bz)
- `kp_index` - Planetary K-index (geomagnetic activity)
- `xray_flux` - GOES X-ray flux (solar flares)
- `proton_flux` - GOES proton flux (radiation storms)

### ServiceMonitor (Prometheus Operator)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceMonitor.enabled` | Enable ServiceMonitor | `false` |
| `serviceMonitor.interval` | Scrape interval | `60s` |
| `serviceMonitor.scrapeTimeout` | Scrape timeout | `30s` |
| `serviceMonitor.labels` | Additional labels | `{}` |
| `serviceMonitor.annotations` | Additional annotations | `{}` |

## Examples

### Minimal Installation

```bash
helm install nasa-swpc-exporter ./nasa-swpc-exporter-chart
```

### With Prometheus Operator

```yaml
# values-prometheus.yaml
serviceMonitor:
  enabled: true
  interval: 60s
  labels:
    prometheus: kube-prometheus
```

```bash
helm install nasa-swpc-exporter ./nasa-swpc-exporter-chart -f values-prometheus.yaml
```

### Custom Collectors

```yaml
# values-custom.yaml
config:
  measureInterval: 30
  collectors: "kp_index,xray_flux,proton_flux"
```

```bash
helm install nasa-swpc-exporter ./nasa-swpc-exporter-chart -f values-custom.yaml
```

### Production Configuration

```yaml
# values-production.yaml
replicaCount: 2

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

serviceMonitor:
  enabled: true
  interval: 60s
  labels:
    prometheus: kube-prometheus

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app.kubernetes.io/name
            operator: In
            values:
            - nasa-swpc-exporter
        topologyKey: kubernetes.io/hostname
```

```bash
helm install nasa-swpc-exporter ./nasa-swpc-exporter-chart -f values-production.yaml
```

## Upgrading

```bash
helm upgrade nasa-swpc-exporter ./nasa-swpc-exporter-chart
```

## Uninstalling

```bash
helm uninstall nasa-swpc-exporter
```

## Metrics

The exporter exposes the following metrics:

- **Solar Wind**: `solar_wind_plasma_*`, `solar_wind_mag_*`
- **Geomagnetic**: `kp_index`
- **Solar Radiation**: `xray_flux_*`, `proton_flux_*`

See the [telemetry documentation](../../docs/telemetry.md) for complete metric details.

## Alerts

Pre-configured Prometheus alerts are available in the mixin at `mixins/nasa-swpc-mixin/alerts.libsonnet`.

See the [alerts documentation](../../docs/alerts.md) for alert details.

## Troubleshooting

### Check pod status

```bash
kubectl get pods -l app.kubernetes.io/name=nasa-swpc-exporter
```

### View logs

```bash
kubectl logs -l app.kubernetes.io/name=nasa-swpc-exporter
```

### Test metrics endpoint

```bash
kubectl port-forward svc/nasa-swpc-exporter 9468:9468
curl http://localhost:9468/metrics
```

## License

See the main repository LICENSE file.
