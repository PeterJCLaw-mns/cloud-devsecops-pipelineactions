---
id: automated-cr
title: Automated Change Process
# prettier-ignore
description: Lean Change Management - Automated Change Request
---

# Lean Change Management - Automated Change Request

As part of the journey towards Continuous Deployment, we have created Automated CR (Change Request) composite actions using which you will be able to create CR, check conflicts through pipeline itself rather than manually raising the CR in BMC Remedy. 

**Tools involved**: BMC Helix iPaaS, BMC Remedy

### **How to Consume - Non-Production**:

**Step 1**: Go to the New worklfow section in your repo (<a href="https://github.com/DigitalInnovation/{{your-repo-name}}/actions/new">https://github.com/DigitalInnovation/{your-repo-name}/actions/new</a>), as shown below and select 'M&S - Automated CR workflow' workflow in order to get your automated CR workflow which performs below and **commit** the workflow file in your repository,
 - Display Conflict details based on your Scheduled start and end date
 - Create CR and return the CR number created in BMC Remedy based on your input selection 
 
![image](https://user-images.githubusercontent.com/19665606/227310447-ce93d134-3edd-4d06-b0d9-42197875f272.png)

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
{% raw %}
      uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD/bmc-helix-cr-qa@latest
      with:
        action: "update"
        bmc_username: GitHub.APIUser
        bmc_password: ${{ secrets.BMC_REMEDY_API_PASSWORD  }}
        helix_username: github
        helix_password: ${{ secrets.BMC_HELIX_API_PASSWORD  }}
        change_request_id: ${{ github.event.inputs.change_request_id }}
        update_status: "Implementation In Progress"
        update_reason: ""
        {% endraw %}
```
Snippet to be added **after** Production deployment step, also add a condition to run this step only **if the deployment is successful** :

```
{% raw %}
      uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD/bmc-helix-cr-qa@latest
      with:
        action: "update"
        bmc_username: GitHub.APIUser
        bmc_password: ${{ secrets.BMC_REMEDY_API_PASSWORD  }}
        helix_username: github
        helix_password: ${{ secrets.BMC_HELIX_API_PASSWORD  }}
        change_request_id: ${{ github.event.inputs.change_request_id }}
        update_status: "Completed"
        update_reason: "Final Review Complete"
        {% endraw %}
```

**Step 4**: **Run** the workflow which you have committed in **Step 1** by providing the below input values as per your Product,

| S.No | Workflow dispatch inputs | Remarks | Example | Mandatory / Optional | 
| ------------- | ------------------------------------------- | ----------------------------- | --------------|---------------------- |
| 1 | Change Initiated Portfolio | Input your Portfolio name | Foods | mandatory | 
| 2 | Change Implementation Start Date (YYYY-MM-DDTHH:MM:SS).Provide future date | Input your Scheduled start date in the format, YYYY-MM-DDTHH:MM:SS and also provide future time | 2023-01-28T05:00:00 | mandatory | 
| 3 | Change Implementation End Date (YYYY-MM-DDTHH:MM:SS).Provide future date | Input your Scheduled end date in the format, YYYY-MM-DDTHH:MM:SS and also provide future time and value greater than start date | 2023-01-28T08:00:00 | mandatory | 
| 4 | Application Name | Input your Application name | Transport Management System (TMS) | mandatory | 
| 5 | Change Description | Input your Change description along with Impact statement, Test evidence links | Sample: This change is about the enabling logging in the application | mandatory | 
| 6 | Change Category | Input your Change Category | Application | mandatory | 
| 7 | Outage Required? | Input if your change requires outage | Yes/No | mandatory | 
| 8 | Product 4 Wall Change? | Input if your change is Product 4 wall change | Yes | mandatory | 
| 9 | Business Impact | Provide your Business Impact | Sample: Test Business Impact | mandatory | 
| 10 | For Risk and Impact assessment agreement, please refer this link - | Please go through the R&I assessment and agree | Yes | mandatory | 

**Step 5**: Once the above workflow is completed, CR will be created. Obtain the CR approval and pass CR number, other paramter(s) to your existing 'Release to Production' workflow in order to complete the Production deployment. 

**Note:**
- In case of the **microservices deployment** involving multiple repos, please provide the list of repos involved in the 'Detailed description' field while creating CR and refer the same CR in all your deployment pipelines

Please refer below high level overview on Automated CR for Phase 1 - 4 wall change without outage (with approval) explaining the above steps,
![image](https://user-images.githubusercontent.com/19665606/221855811-98782e2e-81bb-449f-9530-99ea5bde80c3.png)

Reference workflows for this Automated CR, <br>
<a href="https://github.com/DigitalInnovation/cloud-devsecops-demo/blob/main/.github/workflows/cloud9-devsecops-automated-cr-workflow.yml">Create CR</a> <br>
<a href="https://github.com/DigitalInnovation/cloud-devsecops-demo/blob/main/.github/workflows/bmc_update_cr_comp_actions.yml">Update CR</a>

### **How to Consume - Production**:

**Step 1**: Go to the New worklfow section in your repo (<a href="https://github.com/DigitalInnovation/{{your-repo-name}}/actions/new">https://github.com/DigitalInnovation/{your-repo-name}/actions/new</a>), as shown below and select 'M&S - Automated CR workflow' workflow in order to get your automated CR workflow which performs below and **commit** the workflow file in your repository,
 - Display Conflict details based on your Scheduled start and end date
 - Create CR and return the CR number created in BMC Remedy based on your input selection 
 
![image](https://user-images.githubusercontent.com/19665606/227310348-1bb6e7c1-7f72-4ea9-94e7-00b26e8366d6.png)

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
{% raw %}
      uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD/bmc-helix-cr-prod@latest
      with:
        action: "update"
        bmc_username: GitHub.APIUser
        bmc_password: ${{ secrets.PROD_BMC_REMEDY_API_PASSWORD  }}
        helix_username: github
        helix_password: ${{ secrets.PROD_BMC_HELIX_API_PASSWORD  }}
        #change_request_id: ${{ github.event.client_payload.change_request_id }}
        change_request_id: ${{ github.event.inputs.change_request_id }}
        update_status: "Implementation In Progress"
        update_reason: ""
        {% endraw %}
```
Snippet to be added **after** Production deployment step, also add a condition to run this step only **if the deployment is successful** :

```
{% raw %}
      uses: DigitalInnovation/cloud-devsecops-pipelineactions/workflows/CD/bmc-helix-cr-prod@latest
      with:
        action: "update"
        bmc_username: GitHub.APIUser
        bmc_password: ${{ secrets.PROD_BMC_REMEDY_API_PASSWORD  }}
        helix_username: github
        helix_password: ${{ secrets.PROD_BMC_HELIX_API_PASSWORD  }}
        #change_request_id: ${{ github.event.client_payload.change_request_id }}
        change_request_id: ${{ github.event.inputs.change_request_id }}
        update_status: "Completed"
        update_reason: "Final Review Complete"
        {% endraw %}
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
- In case of the **microservices deployment** involving multiple repos, please provide the list of repos involved in the 'Detailed description' field while creating CR and refer the same CR in all your deployment pipelines

Please refer below high level overview on Automated CR for Phase 1 - 4 wall change without outage (with approval) explaining the above steps,
![image](https://user-images.githubusercontent.com/19665606/221855811-98782e2e-81bb-449f-9530-99ea5bde80c3.png)

Reference workflows for this Automated CR, <br>
<a href="https://github.com/DigitalInnovation/cloud-devsecops-demo/blob/main/.github/workflows/cloud9-devsecops-automated-cr-prod-workflow.yml">Create CR</a> <br>
<a href="https://github.com/DigitalInnovation/cloud-devsecops-demo/blob/main/.github/workflows/prod_cr_update.yml">Update CR</a>
