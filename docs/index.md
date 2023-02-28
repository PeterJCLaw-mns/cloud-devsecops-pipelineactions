---
id: Overview-catalog
title: Overview
# prettier-ignore
description: Cloud DevSecOps Reusable Actions
---


# Cloud DevSecOps reusable actions repository
Welcome to the DevSecOps reusable actions repository containing sample reusable composite actions to help you get up and running quickly using M&S standards and best practices.

![Public repository attention](https://img.icons8.com/ios/32/000000/error--v1.png)
**Please note** this repository is **Public** and as such no sensitive data should be stored. 

## Reusable actions
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
  - AKS Helm Deployment
- Observability 
  - New Relic Deployment Marker
- Insights (Coming soon)

The above reusable actions are available for a variety of tech stacks, please see the [Workflows folder](https://github.com/DigitalInnovation/cloud-devsecops-pipelineactions/tree/main/workflows) for more.

### Automated Change Management
As part of the journey towards Continuous Deployment, we have created Automated CR (Change Request) composite actions using which you will be able to create CR, check conflicts through pipeline itself rather than manually raising the CR in BMC Remedy. 

**Tools involved**: BMC Helix iPaaS, BMC Remedy

#### **How to Consume**:

**Step 1**: Go to the New worklfow section in your repo (<a href="https://github.com/DigitalInnovation/{{your-repo-name}}/actions/new">https://github.com/DigitalInnovation/{your-repo-name}/actions/new</a>), as shown below and select 'M&S - Automated CR workflow' workflow in order to get your automated CR workflow which performs below and **commit** the workflow file in your repository,
 - Display Conflict details based on your Scheduled start and end date
 - Create CR and return the CR number created in BMC Remedy based on your input selection 
![image](https://user-images.githubusercontent.com/19665606/212329039-af681422-2d95-4143-b203-21c42410ab8e.png)

**Step 2**: Include the below input parameter in your existing 'Release to Prod' workflow, (CR number will be available in the Step 1 workflow output when you execute it)
```
     change_request_id:
       description: 'Provide the CR number for update workflow'
       required: true
       type: string
```
**Step 3**: Include the below code snippets in your existing 'Release to Production' workflow, before and after the Production deployment step in order to update the CR as 'Implementation in progress' and 'Completed' respectively, so that CR status will be updated properly after the Prodution deploymet is completed,

Snippet to be added **before** Production deployment step:

```
      uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD/bmc-helix-cr@branch-bmc-helix-action
      with:
        action: "update"
        bmc_username: GitHub.APIUser
        bmc_password: ${{ secrets.BMC_REMEDY_API_PASSWORD  }}
        helix_username: github
        helix_password: ${{ secrets.BMC_HELIX_API_PASSWORD  }}
        change_request_id: ${{ github.event.inputs.change_request_id }}
        update_status: "Implementation In Progress"
        update_reason: ""
```
Snippet to be added **after** Production deployment step, also add a condition to run this step only **if the deployment is successful** :

```
      uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD/bmc-helix-cr@branch-bmc-helix-action
      with:
        action: "update"
        bmc_username: GitHub.APIUser
        bmc_password: ${{ secrets.BMC_REMEDY_API_PASSWORD  }}
        helix_username: github
        helix_password: ${{ secrets.BMC_HELIX_API_PASSWORD  }}
        change_request_id: ${{ github.event.inputs.change_request_id }}
        update_status: "Completed"
        update_reason: "Final Review Complete"
```

**Step 4**: **Run** the workflow which you have committed in **Step 1** by providing the below input values as per your Product,

| S.No | Workflow dispatch inputs | Remarks | Example | Mandatory / Optional | 
| ------------- | ------------------------------------------- | ----------------------------- | --------------|---------------------- |
| 1 | Change Initiated Portfolio | Input your Portfolio name | Foods | mandatory | 
| 2 | Change Implementation Start Date (YYYY-MM-DDTHH:MM:SS).Provide future date | Input your Scheduled start date in the format, YYYY-MM-DDTHH:MM:SS and also provide future time | 2023-01-28T05:00:00 | mandatory | 
| 3 | Change Implementation End Date (YYYY-MM-DDTHH:MM:SS).Provide future date | Input your Scheduled end date in the format, YYYY-MM-DDTHH:MM:SS and also provide future time and value greater than start date | 2023-01-28T08:00:00 | mandatory | 
| 4 | Application Name | Input your Application name | Transport Management System (TMS) | mandatory | 
| 5 | Change Description | Input your Change description | Sample: This change is about the enabling logging in the application | mandatory | 
| 6 | Change Category | Input your Change Category | Application | mandatory | 
| 7 | Outage Required? | Input if your change requires outage | Yes/No | mandatory | 
| 8 | Product 4 Wall Change? | Input if your change is Product 4 wall change | Yes | mandatory | 
| 9 | Business Impact | Provide your Business Impact | Sample: Test Business Impact | mandatory | 
| 10 | For Risk and Impact assessment agreement, please refer this link - | Please go through the R&I assessment and agree | Yes | mandatory | 

**Step 5**: Once the above workflow is completed, CR will be created. Obtain the CR approval and pass CR number, other paramter(s) to your existing 'Release to Production' workflow in order to complete the Production deployment. 

**Note:**
- In case of the microservices deployment involving multiple repos, please provide the list of repos involved in the 'Detailed description' field while creating CR and re-fer the same CR in all your deployment pipelines to update the CR status. 
- Composite Action **branch reference** will be changed from **'branch-bmc-helix-action' to 'latest'** once the UAT is completed. 

Please refer below high level overview on Automated CR for Phase 1 - 4 wall change without outage (with approval) explaining the above steps,
![image](https://user-images.githubusercontent.com/19665606/221855811-98782e2e-81bb-449f-9530-99ea5bde80c3.png)

Reference workflows for this Automated CR, <br>
Create CR - https://github.com/DigitalInnovation/cloud-devsecops-demo/blob/main/.github/workflows/cloud9-devsecops-automated-cr-workflow.yml <br>
Update CR - https://github.com/DigitalInnovation/cloud-devsecops-demo/blob/main/.github/workflows/bmc_update_cr_comp_actions.yml

#### **Change Management Risk/Impact Assessment Questionnaire**
 - [ ] The preferred Change window for the change execution is correct and a safe time (non-business/ trading hours wherever possible and not to conflict with business events) to do this change with zero-downtime deployment
- [ ] Change roll back plan is available and tested to ensure changes can be reverted quickly to avoid impacts within the agreed change window
- [ ] Pre-Implementation steps including the necessary pre requites for the change implementation are validated before execution
- [ ] Adequate monitoring and hyper care are in place to ensure the purpose of change is achieved and to identify any issues post deployment
- [ ] Change has been tested E2E wherever possible and the results are validated that is not impacting upstream and downstream applications and services are assessed, and necessary communications are made
- [ ] This Change does not result in capacity growth or if required, necessary uplifts have been made in both primary and DR regions.
- [ ] If the change is impacting M&S Security, approval from the infosec need to be secured to proceed with the change
- [ ] If the change is impacting the DR Capability of the service, ensure the relevant changes are reflecting in the DR component as well.


## Want to contribute?
We openly welcome contributors to enhance and grow our resuable actions to improve M&S engineering experience. Please feel free to raise a pull request against this repo with your suggestions / additions and one of the Cloud DevSecOps team will review. 

## Feedback or Support
Please contact the Cloud DevSecOps teams: itplatformscloudtechnologydevsecops@marks-and-spencer.com


   
