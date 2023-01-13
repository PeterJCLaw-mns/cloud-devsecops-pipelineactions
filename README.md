# Cloud DevSecOps reusable actions repository
Welcome to the DevSecOps reusable actions repository containing sample reusable composite actions to help you get up and running quickly using M&S standards and best practices.

![Public repository attention](https://img.icons8.com/ios/32/000000/error--v1.png)
**Please note** this repository is **Public** and as such no sensitive data should be stored. 


## Reusable actions
The following reusable actions are available for a variety of tech stacks, please see the [Workflows folder](https://github.com/DigitalInnovation/cloud-devsecops-pipelineactions/tree/main/workflows).
- CI
  - Build
  - Artifact publishing 
  - Image publishing
  - Code Quality 
- AppSec
  - Dependency Vulnerability scanning
  - SAST (Static Application Security testing)
  - Container Vulnerability Scanning 
- Artifact and Image Publishing (If required separately from CI)
- Code Quality (If required separately from CI)
- Deployment 
  - Automated Change Management 
  - AKS Helm Deployment
- Observability 
  - New Relic Deployment Marker
  - Pipeline Insights 
  
## Automated Change Management
As part of the journey towards Continuous Deployment, we have created Automated CR (Change Request) composite actions using which you will be able to create CR, check conflicts through pipeline itself rather than manually raising the CR in BMC Remedy. 

**Tools involved**: BMC Helix iPaaS, BMC Remedy

### **How to Consume**:

**Step 1**: Go to the New worklfow section in your repo (https://github.com/DigitalInnovation/{{your-repo-name}}/actions/new), as shown below and select 'M&S - Automated CR workflow' workflow in order to get your automated CR workflow which performs,
 - Display Conflict details based on your Scheduled start and end date
 - Create CR and return the CR number created in BMC Remedy based on your input selection 
![image](https://user-images.githubusercontent.com/19665606/212329039-af681422-2d95-4143-b203-21c42410ab8e.png)

**Step 2**: Commit the workflow file in your repository

**Step 3**: Include the below trigger condition in your 'Release to Prod' workflow, 
```
  repository_dispatch:
     types:
       - remedyautocr
```

**Step 4**: Run the workflow which you have committed in Step 2 by providing the below input values as per your Product,
| S.No | Workflow dispatch inputs | Remarks | Example | Mandatory / Optional | 
| ------------- | ------------------------------------------- | ----------------------------- | --------------|---------------------- |
| 1 | Change Initiated Portfolio | Input your Portfolio name | Foods | mandatory | 
| 2 | Change Implementation Start Date (YYYY-MM-DDTHH:MM:SS).Provide future date | Input your Scheduled start date in the format, YYYY-MM-DDTHH:MM:SS and also provide future date | 2023-01-28T05:00:00 | mandatory | 
| 3 | Change Implementation End Date (YYYY-MM-DDTHH:MM:SS).Provide future date | Input your Scheduled end date in the format, YYYY-MM-DDTHH:MM:SS and also provide future date and value greater than start date | 2023-01-28T08:00:00 | mandatory | 
| 4 | Application Name | Input your Application name | Transport Management System (TMS) | mandatory | 
| 5 | Change Description | Input your Change description | Sample: This change is about the enabling logging in the application | mandatory | 
| 6 | Change Category | Input your Change Category | Application | mandatory | 
| 7 | Outage Required? | Input if your change requires outage | Yes/No | mandatory | 
| 8 | Product 4 Wall Change? | Input if your change is Product 4 wall change | Yes | mandatory | 
| 9 | Business Impact | Provide your Business Impact | Sample: Test Business Impact | mandatory | 
| 10 | For Risk and Impact assessment agreement, please refer this link - | Please go through the R&I assessment and agree | Yes | mandatory | 


## Insights 
The insights workflow sends the pipeline run metrics to New Relic events db based on the New Relic Account ID and API Key provided as secrets.
  
  **How to Consume**
  
  1. Below is the sample reusable workflow trigger, which should be part of the 'main' branch of the repository. It gets triggered, everytime when there is a workflow run completion. By default the workflow trigger file will be part of the repositories which are created from Brightcloud. 
  If the repository is not created from Brightcloud, please follow the below step.
     
     - Copy the workflow file to the **_.github/workflows_** directory in _**main**_ branch.
     
     https://github.com/DigitalInnovation/Cloud-DevSecOps-Reusable-Templates/blob/main/.github/workflows/pipeline-insights-reusable-template.yaml
     
  2. Pipeline Metrics data is being sent to the below event tables in New Relic.
  
     - `**pipelinemetricsdb** -> Contains the details about the workflow`
     - `**pipelinejobmetricsdb** -> Contains the details about the Jobs in each workflow`
      
   - You can duplicate the below Demo Dashbaord to view the metrics.
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

     
     
## Want to contribute?
We openly welcome contributors to enhance and grow our resuable actions to improve M&S engineering experience. Please feel free to raise a pull request against this repo with your suggestions / additions and one of the Cloud DevSecOps team will review. 

## Consumer Registry
Refer cloud-devsecops-pipelineactions [wiki](https://github.com/DigitalInnovation/cloud-devsecops-pipelineactions/wiki) page.
- [Product Teams repositort list](https://github.com/DigitalInnovation/cloud-devsecops-pipelineactions/wiki/Product_Team_Repository_List)

## Documentation
- [Semantic versioning](docs/semantic_versioning.md)

## Feedback or Support
Please contact the Cloud DevSecOps teams: itplatformscloudtechnologydevsecops@marks-and-spencer.com


   

