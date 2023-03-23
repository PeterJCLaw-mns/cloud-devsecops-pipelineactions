---
id: insights
title: Pipeline Insights
# prettier-ignore
description: Pipeline insights 
---

# Insights 
The insights workflow sends the pipeline run metrics to New Relic events db based on the New Relic Account ID and API Key provided as secrets.
  
  **How to Consume**
  
  1. Below is the sample reusable workflow trigger, which should be part of the 'main' branch of the repository. It gets triggered, everytime when there is a workflow run completion. By default the workflow trigger file will be part of the repositories which are created from Brightcloud. 
  If the repository is not created from Brightcloud, please follow the below step.
     
     - Copy the workflow file to the **_.github/workflows_** directory in _**main**_ branch.
     
     https://github.com/DigitalInnovation/Cloud-DevSecOps-Reusable-Templates/blob/main/.github/workflows/pipeline-insights-reusable-template.yaml
     
  2. Pipeline Metrics data is being sent to the below event tables in New Relic.
  
     - ` __ pipelinemetricsdb__ -> Contains the details about the workflow`
     - ` **pipelinejobmetricsdb** -> Contains the details about the Jobs in each workflow`
      
   - You can duplicate the below Demo Dashboard to view the metrics.
    https://onenr.io/0bRK984bEQE

   - Or you can use the below sample queries to view in New Relic Dashboard (Custom queries can be created based on the data) 
     - * _FROM pipelinemetricsdb SELECT latest(Repository_Name) as 'Repository Name' Facet Repo_ID SINCE 7 days ago_
     - * _FROM pipelinemetricsdb SELECT latest(Total_Duration) FACET Workflow_ID SINCE 7 days ago TIMESERIES 30 minutes LIMIT MAX_
     - * _FROM pipelinejobmetricsdb SELECT latest(Job_Duration) FACET Workflow_ID,Job_Name SINCE 7 days ago TIMESERIES 30 minutes  LIMIT MAX_
      
   - If you are unable to view the demo dashbaord because of permission issue, then please use the below json to create the dashbaord.
     - Copy the below given JSON
     - Replace the value for all the entries of **_accountId_** with your NewRelic account ID.
     - Go to NewRelic -> Dashbaord
     - Click on **Import Dashbaord** and paste the json and create the dashbaord.
     
<details><summary>Click here for the JSON snippet</summary>

```json
  
{
  "name": "Cloud9-DevSecOps-Githubaction-Pipeline-insights",
  "description": null,
  "permissions": "PUBLIC_READ_WRITE",
  "pages": [
    {
      "name": "Cloud9-DevSecOps-Githubaction-Pipeline-insights",
      "description": null,
      "widgets": [
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 1,
            "width": 12,
            "height": 1
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "# Github Pipeline Insights - DevSecOps!  ![New Relic logo](https://newrelic.com/static-assets/images/icons/avatar-newrelic.png)\n> **Use the below filters to get the insights of your `Repository`/ `Workflow`**\n"
          }
        },
        {
          "title": "Filter - Repository Name",
          "layout": {
            "column": 1,
            "row": 2,
            "width": 2,
            "height": 3
          },
          "linkedEntityGuids": [
            "MzAyMDQwM3xWSVp8REFTSEJPQVJEfDQ3MzI3Njg"
          ],
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT latest(Repository_Name) as 'Repository Name' Facet Repo_ID SINCE 7 days ago"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Filter - Workflow ID/ Name",
          "layout": {
            "column": 3,
            "row": 2,
            "width": 3,
            "height": 3
          },
          "linkedEntityGuids": [
            "MzAyMDQwM3xWSVp8REFTSEJPQVJEfDQ3MzI3Njg"
          ],
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT latest(Workflow_Name) FACET Workflow_ID SINCE 7 days ago LIMIT MAX"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Workflow Status",
          "layout": {
            "column": 6,
            "row": 2,
            "width": 2,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.pie"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": true
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT count(*) facet Workflow_Status SINCE 7 days ago LIMIT max"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Filter - Run Number",
          "layout": {
            "column": 8,
            "row": 2,
            "width": 3,
            "height": 3
          },
          "linkedEntityGuids": [
            "MzAyMDQwM3xWSVp8REFTSEJPQVJEfDQ3MzI3Njg"
          ],
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT latest(Run_Number) FACET Run_Id SINCE 7 days ago LIMIT MAX "
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Workflow Success Rate",
          "layout": {
            "column": 11,
            "row": 2,
            "width": 2,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.billboard"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT percentage(count(*), WHERE Workflow_Status = 'success') as 'Workflow Success Rate' FACET Workflow_ID,Workflow_Name SINCE 7 days ago LIMIT MAX "
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "thresholds": [
              {
                "alertSeverity": "WARNING",
                "value": 0.75
              },
              {
                "alertSeverity": "CRITICAL",
                "value": 0.5
              }
            ]
          }
        },
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 5,
            "width": 12,
            "height": 1
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "# Insights Data"
          }
        },
        {
          "title": "Total Duration - In Seconds",
          "layout": {
            "column": 1,
            "row": 6,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.line"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": true
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT latest(Total_Duration) FACET Workflow_ID SINCE 7 days ago TIMESERIES 30 minutes LIMIT MAX"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "yAxisLeft": {
              "zero": true
            }
          }
        },
        {
          "title": "Run Number",
          "layout": {
            "column": 5,
            "row": 6,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.line"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": true
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinejobmetricsdb SELECT latest(Run_Number) FACET Workflow_ID SINCE 7 days ago TIMESERIES 30 minutes LIMIT MAX"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "yAxisLeft": {
              "zero": true
            }
          }
        },
        {
          "title": "Job Details - Runtime in Seconds",
          "layout": {
            "column": 9,
            "row": 6,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.stacked-bar"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": true
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinejobmetricsdb SELECT latest(Job_Duration) FACET Workflow_ID,Job_Name SINCE 7 days ago TIMESERIES 30 minutes  LIMIT MAX"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Github Workflow Runtime  - All Runs | Use this for Filtering",
          "layout": {
            "column": 1,
            "row": 9,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT Repository_Name,Branch,Workflow_Name,Workflow_ID,Actor,Run_Number,Total_Duration as 'Total Duration in Seconds',Workflow_Status, Run_Started, Run_Ended SINCE 7 days ago limit max"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Jobs Details",
          "layout": {
            "column": 5,
            "row": 9,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": true
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinejobmetricsdb SELECT  Workflow_ID,Run_Number,Job_Name,Job_Duration as 'Job Run time in seconds',Job_Status  SINCE 7 days ago LIMIT MAX"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "No of Workflow run by Actor",
          "layout": {
            "column": 9,
            "row": 9,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT count(*) FACET Actor since 7 days ago"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Total Number of pipeline Runs - in Last Month",
          "layout": {
            "column": 1,
            "row": 12,
            "width": 4,
            "height": 1
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.bar"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT count(Run_Id) FACET Workflow_ID,Workflow_Name SINCE 7 days ago"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Most failed Jobs",
          "layout": {
            "column": 5,
            "row": 12,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.bar"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinejobmetricsdb SELECT count(Job_Name) where Job_Status = 'failure' FACET Workflow_ID,Job_Name SINCE 7 days ago LIMIT max"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Trend - Average Execution time ",
          "layout": {
            "column": 9,
            "row": 12,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.area"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT average(Total_Duration) as 'Average Total Execution Time' facet Workflow_Name,Workflow_ID SINCE last week TIMESERIES Limit max"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "Max/Min Run time in last Month",
          "layout": {
            "column": 1,
            "row": 13,
            "width": 4,
            "height": 2
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 1234567,
                "query": "FROM pipelinemetricsdb SELECT max(Total_Duration) as 'Max Duration in seconds', min(Total_Duration) as 'Min Duration in seconds',average(Total_Duration) as 'Average Duration' FACET Workflow_ID SINCE last month"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        }
      ]
    }
  ]
}
  
```

</details>
