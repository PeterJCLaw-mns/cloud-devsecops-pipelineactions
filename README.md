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
  - AKS Helm Deployment. (Supports blue-green release strategy. [Refer below for more details.](https://github.com/DigitalInnovation/cloud-devsecops-pipelineactions/blob/devsecops_blue_green_deployment/README.md#blue---green-release-strategy-for-aks-helm-deployment))
- Observability 
  - New Relic Deployment Marker
  - Pipeline Insights 
  
### Automated Change Management
As part of the journey towards Continuous Deployment, we have created Automated CR (Change Request) composite actions using which you will be able to create CR, check conflicts through pipeline itself rather than manually raising the CR in BMC Remedy. 

Refer the [link](https://digitalinnovation.github.io/cloud-devsecops-pipelineactions/automated-change-process.html) for more detailed steps on the consumption of this Automated CR composite actions. 


### Insights 
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

## Blue - Green Release strategy for AKS Helm deployment
Blue/green deployments provide releases with near zero-downtime and rollback capabilities. We have added an option for the teams to select the release strategy - 'bluegreen', within the starter pipeline. This lets the team to deploy two instances of the application, blue and green accordingly. We are assuming the '**_blue_**' instance as the production instance and the **_green_** instance will run as the test/stage instance.
### How to use?
We have added a new parameter: **release_strategy** in the helm deployment composite action (DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD@latest). 
```
release_strategy -> Three values are available to use with this parameter - bluegreen, greentoblue, overrideblue
```
```yaml
Helm_deployment:
    runs-on: ubuntu-latest
    needs: [ pre-work-setup , Build_Test_and_Deploy_Package ]
    # set the environment variable for job to use environement specific Secrets if configured.
    environment: Nonprod
    continue-on-error: true
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3
      - name: Deploy application 
        uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD@latest
        with:
          ## Other Parameters defined in the composite action##
          release_strategy: bluegreen | greentoblue | overrideblue
```
**parameter values:** 
  - `release_strategy=bluegreen : By using this value, blue and green releases gets deployed. The very first deployment will be deployed in blue slot and the consequtive builds will be deployed in green slot.`
  - `release_strategy=greentoblue : By using this option, the build from the green(test/stage) slot can be moved to the blue(production) slot. This will take the docker image used in the green slot for deployment. For an added check, this also checks if the user provided docker image name and tag are same as the one used in green slot. Once the blue slot is updated, the green slot will get deleted.` 
  - `release_strategy=overrideblue : By using this option, user can directly deploy to the blue slot, instead of testing in the green slot.`

> **Pre-requisites:** image repository name should be defined in the values.yml file of your helm chart.
```yaml
image:
  repository: <<your_image_name>>
  pullPolicy: IfNotPresent
```
### Blue - Green Release strategy with Canary
We have also added an option to use Canary with Blue-Green. With this, teams will be able to test new versions of the application within the production itself, by directing a percentage of the traffic to the new version. This can be done in small phases (e.g: 2%, 25%, 75%, 100%). A canary release is the lowest risk-prone, because of this control. 
We have made this working using the Ngnix ingress annotations for canary deployment. This updates the backend ingress of the green deployment with the annotation and canary weightage.

**ingress anotations:** 
  - `nginx.ingress.kubernetes.io/canary: "false"
    nginx.ingress.kubernetes.io/canary-weight: "10"`
 
### How to use?
To enable canary, the parameter '**enable_canary**' should be set as '**True**', and the canary weightage should be given with the parameter '**canary_weightage**'.
The **release_strategy** value  should be 'bluegreen'

```yaml
Helm_deployment:
    runs-on: ubuntu-latest
    needs: [ pre-work-setup , Build_Test_and_Deploy_Package ]
    # set the environment variable for job to use environement specific Secrets if configured.
    environment: Nonprod
    continue-on-error: true
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3
      - name: Deploy application 
        uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD@latest
        with:
          ## Other Parameters defined in the composite action##
          release_strategy: bluegreen
          enable_canary: true
          canary_weightage: 10
          
``` 

> **Pre-requisites:** ingress and canary annotation part should be given in the Values.yaml file as below. 
```yaml
ingress:
  enabled: true
  tls: true
  annotations: 
    kubernetes.io/ingress.class: nginx-platform
    meta.helm.sh/release-name: ""
    meta.helm.sh/release-namespace: ""
    nginx.ingress.kubernetes.io/canary: "false"
    nginx.ingress.kubernetes.io/canary-weight: "10"
  hosts:
    - host: <<host URL>>
      paths:
        - /
```
## Rollback
Rollback to the previous version of the release is possible with the same parameter. The below values can be used accordingly to rollback the release.

**parameter values:** 
  - `release_strategy=rollbackblue : By using this value, blue release can be rolled back to the previous version.`
  - `release_strategy=rollbackgreen : By using this value, green release can be rolled back to the previous versiond.` 
  - `release_strategy=deletegreen : By using this value, green (stage/test) release can be removed completely.`

> **Important Note:** As of now, we recommend this solution only for the teams who are deploying stateless application, as the solution currently do not support handling the backen db. Teams can use it for statefull applications, if they can handle the backend db scenerios when using the canary release strategy. 

## Want to contribute?
We openly welcome contributors to enhance and grow our resuable actions to improve M&S engineering experience. Please feel free to raise a pull request against this repo with your suggestions / additions and one of the Cloud DevSecOps team will review. 

## Consumer Registry
Refer cloud-devsecops-pipelineactions [wiki](https://github.com/DigitalInnovation/cloud-devsecops-pipelineactions/wiki) page.
- [Product Teams repositort list](https://github.com/DigitalInnovation/cloud-devsecops-pipelineactions/wiki/Product_Team_Repository_List)

## Documentation
- [Semantic versioning](docs/semantic_versioning.md)

## Feedback or Support
Please contact the Cloud DevSecOps teams: itplatformscloudtechnologydevsecops@marks-and-spencer.com


   

