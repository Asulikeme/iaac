### Dashboards

|Cloud Storage Monitoring|
|:-----------------------|
|Filename: [cloud-storage-monitoring.json](cloud-storage-monitoring.json)|
|This dashboard has 6 charts for the related [Cloud Storage metrics](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-storage), including `Total object count`, `Total bytes`, `Bucket object count`, `Bucket total bytes`, `Bucket - Received/Sent Bytes`, and `Bucket - Request count`.|

&nbsp;

|Logging Usage - Cloud SQL|
|:-----------------------|
|Filename: [cloudsql-usage.json](cloudsql-usage.json)|
|This dashboard primarily looks at the `Log Bytes Sent` and `Log Entries` metrics but also adds in some additional visualizations of `Entries By Severity` for monitored resources of `cloudsql_database` and `cloudsql_instance_database`.|

&nbsp;

|Cloud SQL Monitoring|
|:-------------------|
|Filename: [cloudsql-monitoring.json](cloudsql-monitoring.json)|
|This dashboard has 10 charts for the related [Cloud SQL metrics](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-cloudsql), including `Instance state`, `Server up`, and CPU/Memory/Disk utilization etc. This dashboard provides an aggregate view of total resources of your SQL databases. You can use database engine-specific dashboards for additional metrics of different database engines such as MySQL and PostgreSQL.

&nbsp;

|Cloud SQL(PostgreSQL) Monitoring|
|:-------------------------------|
|Filename: [cloudsql-postgre-monitoring.json](cloudsql-postgre-monitoring.json)
|This dashboard has 3 charts for the [Cloud SQL(PostgreSQL) metrics](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-cloudsql), including `Number of transactions`, `Connections`, and `Lag bytes`.

&nbsp;

|Logging Usage - GCE|
|:-----------------------|
|Filename: [gce-usage.json](gce-usage.json)|
|This dashboard is fairly simple in that it primarily looks at the `Log Bytes Sent` and `Log Entries` metrics but also adds in some additional visualizations of `Entries By Severity`.|

&nbsp;

|GCE VM Instance Monitoring|
|:-------------------------|
|Filename: [gce-vm-instance-monitoring.json](gce-vm-instance-monitoring.json)|
|This dashboard has 10 charts for the related [GCE VM metrics](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-compute), including metrics for CPU, disk read/write, and network.|