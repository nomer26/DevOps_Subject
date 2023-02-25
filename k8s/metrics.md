### Node CPU & Memory Usage

**CPU**

*query*
```bash
curl -fs --data-urlencode 'query=(sum by (instance,nodename) \
(irate(node_cpu_seconds_total{mode!~"guest.*|idle|iowait"}[5m])) \ 
+ on(instance) group_left(nodename) node_uname_info) -1 ' \
localhost:9090/api/v1/query | jq
```
*result*
```json
{
  "status": "success",
  "data": {
    "resultType": "vector",
    "result": [
      {
        "metric": {
          "instance": "10.0.2.121:9100",
          "nodename": "ip-10-0-2-121.ap-northeast-2.compute.internal"
        },
        "value": [
          1677331665.516,
          "0.047333333333333005"
        ]
      },
      {
        "metric": {
          "instance": "10.0.3.197:9100",
          "nodename": "ip-10-0-3-197.ap-northeast-2.compute.internal"
        },
        "value": [
          1677331665.516,
          "0.04799999999999982"
        ]
      }
    ]
  }
}
```
**Memory**

*query*

```bash
curl -fs
--data-urlencode 'query=((node_memory_MemTotal_bytes  + on(instance) group_left(nodename) \
node_uname_info) - (node_memory_MemAvailable_bytes  + on(instance) group_left(nodename) \
node_uname_info))' localhost:9090/api/v1/query | jq
```
*result*
```json
{
  "status": "success",
  "data": {
    "resultType": "vector",
    "result": [
      {
        "metric": {
          "app_kubernetes_io_component": "metrics",
          "app_kubernetes_io_instance": "prometheus",
          "app_kubernetes_io_managed_by": "Helm",
          "app_kubernetes_io_name": "prometheus-node-exporter",
          "app_kubernetes_io_part_of": "prometheus-node-exporter",
          "app_kubernetes_io_version": "1.5.0",
          "helm_sh_chart": "prometheus-node-exporter-4.8.1",
          "instance": "10.0.2.121:9100",
          "job": "kubernetes-service-endpoints",
          "namespace": "prometheus",
          "node": "ip-10-0-2-121.ap-northeast-2.compute.internal",
          "nodename": "ip-10-0-2-121.ap-northeast-2.compute.internal",
          "service": "prometheus-prometheus-node-exporter"
        },
        "value": [
          1677331569.441,
          "727244800"
        ]
      },
      {
        "metric": {
          "app_kubernetes_io_component": "metrics",
          "app_kubernetes_io_instance": "prometheus",
          "app_kubernetes_io_managed_by": "Helm",
          "app_kubernetes_io_name": "prometheus-node-exporter",
          "app_kubernetes_io_part_of": "prometheus-node-exporter",
          "app_kubernetes_io_version": "1.5.0",
          "helm_sh_chart": "prometheus-node-exporter-4.8.1",
          "instance": "10.0.3.197:9100",
          "job": "kubernetes-service-endpoints",
          "namespace": "prometheus",
          "node": "ip-10-0-3-197.ap-northeast-2.compute.internal",
          "nodename": "ip-10-0-3-197.ap-northeast-2.compute.internal",
          "service": "prometheus-prometheus-node-exporter"
        },
        "value": [
          1677331569.441,
          "562638848"
        ]
      }
    ]
  }
}
```



### NGINX  CPU & Memory Usage

**CPU**

*query*
```bash
curl -fs --data-urlencode \ 
'sum(rate(container_cpu_usage_seconds_total{pod="exem-nginx-79b6d9cb55-h47mm"}[5m]))' \ 
localhost:9090/api/v1/query | jq
```
*result*
```json
{
  "status": "success",
  "data": {
    "resultType": "vector",
    "result": [
      {
        "metric": {},
        "value": [
          1677332414.711,
          "0"
        ]
      }
    ]
  }
}
```
**Memory**

*query*
```bash
curl -fs --data-urlencode \ 
'sum(container_memory_usage_bytes{pod="exem-nginx-79b6d9cb55-h47mm"})' \ 
localhost:9090/api/v1/query | jq
```
*result*
```json
{
  "status": "success",
  "data": {
    "resultType": "vector",
    "result": [
      {
        "metric": {},
        "value": [
          1677332441.215,
          "5591040"
        ]
      }
    ]
  }
}
```
