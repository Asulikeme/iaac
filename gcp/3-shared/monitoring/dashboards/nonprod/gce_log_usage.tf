resource "google_monitoring_dashboard" "gce_log_usage" {
  dashboard_json = <<EOF
  {
  "displayName": "Logging Usage - GCE",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 4,
        "widget": {
          "title": "Bytes Ingested",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "groupByFields": [
                        "resource.label.\"project_id\"",
                        "resource.label.\"instance_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/byte_count\" resource.type=\"gce_instance\"",
                    "secondaryAggregation": {
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"project_id\"",
                        "resource.label.\"instance_id\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "yPos": 1
      },
      {
        "height": 4,
        "widget": {
          "title": "Entries Ingested",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "groupByFields": [
                        "resource.label.\"project_id\"",
                        "resource.label.\"instance_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"gce_instance\"",
                    "secondaryAggregation": {
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"project_id\"",
                        "resource.label.\"instance_id\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 6,
        "yPos": 1
      },
      {
        "height": 1,
        "widget": {
          "text": {
            "format": "RAW"
          },
          "title": "GCE Instances"
        },
        "width": 12
      },
      {
        "height": 4,
        "widget": {
          "title": "Entries By Severity",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "groupByFields": [
                        "metric.label.\"severity\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"gce_instance\"",
                    "secondaryAggregation": {
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [
                        "metric.label.\"severity\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "yPos": 5
      }
    ]
  }
}
EOF
}