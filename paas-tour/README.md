# PaaS Tour

This lab does a tour of a few *Platform as a Service* (PaaS).

## Lab objectives

Getting familiar with the concept of PaaS, the different shape they can take and how they connect to the rest of Azure.

## Prerequisites

We recommend going through our [ARM Introduction](https://github.com/vplauzon/azure-training/tree/master/arm-intro) lab.

## Deployment

In order to save time and because the focus isn't about creating the PaaS resources within the portal, let's deploy the PaaS resources we are going to use:

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fvplauzon%2Fazure-training%2Fmaster%2Fpaas-tour%2Fpaas-tour-arm-template.json)

We suggest to deploy the content in a resource group named *paas-tour* located in region *East US 2*.

The parameter **Prefix** is used to make some resource name unique.  We recommend using the initial of your name & some number, e.g. *vpl42*.

## Clean Up (CLI)

Let's clean up the resource group we have created.

The following commands bypass the "Are you sure you want to perform this operation?".  Be careful you do not do this with resource groups containing valuable resources.

Type:  `az group delete --name paas-tour --no-wait -y`

(If you used a different resource group name than *paas-tour*, change that in the command)

The commands do not prompt and return before the resource groups are deleted.  It deletes the resources under the resource group before deleting the resource group.  The deletion should take a few minutes.