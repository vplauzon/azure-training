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

## Azure SQL DB

Let's first look at the 2 resources related to Azure SQL DB.

![SQL Resources](images/sql-resources.png)

Let's first open the *SQL Server* resource.

As opposed to its on-premise counterpart, the Azure SQL Server is a *logical* server. It acts as a container for databases.  It holds configuration common to the databases, e.g. collation, location & server admin.  It doesn't hold the compute nor does it accrues charges.

1. The server resource holds the firewall rules ; let's look at them
![Firewalls on the menu](images/firewalls-menu.png)
1. By default, we can see there are no firewall rules and no virtual network integration
We will come back to that screen.

Let's open the SQL Database resource.

1. The database is a compute resource:  it has a pricing tier & an endpoint
![Firewalls on the menu](images/db-overview.png)
1. Let's look at data encryption
![Data Encryption on the menu](images/data-encryption-menu.png)
By default *Transparent Data Encryption* is activated
![Data Encryption on the menu](images/data-encryption.png)
It is an opt-out option.  It is set at the database level.
1. Let's look at geo-replication
![Data Encryption on the menu](images/geo-replication-menu.png)
1. We can set replica in any regions ; let's select East-US
![East US](images/east-us.png)
1. This leads us to the following form:
![East US](images/geo-replication-form.png)
1. It is interesting to look at the form to understand the mechanisms of geo replication
   * We can control on which *SQL Server* the replica will land
      * Since a *SQL Server* is bound to a region, a replica must necessarily go to another server
   * The replica can be of a different pricing tier than the primary.  This can be interesting if the replica is used primarily for DR.  In that case we might want to drop the compute capacity in order to control cost.
1.  Let's connect to the database.  We could do that with any SQL Server tool, since Azure SQL DB behaves like any SQL Database.  For simplicity let's take the tool available in the portal:

## Azure Cosmos DB

## Azure Functions

## Logic Apps

## Databricks

## Clean Up (CLI)

Let's clean up the resource group we have created.

The following commands bypass the "Are you sure you want to perform this operation?".  Be careful you do not do this with resource groups containing valuable resources.

Type:  `az group delete --name paas-tour --no-wait -y`

(If you used a different resource group name than *paas-tour*, change that in the command)

The commands do not prompt and return before the resource groups are deleted.  It deletes the resources under the resource group before deleting the resource group.  The deletion should take a few minutes.