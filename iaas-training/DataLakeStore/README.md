# Azure Data Lake Store Lab

## Lab Objectives

Create an Azure Data Lake Store (ADLS) account, populate a hierarchy & configure access control.

### Create account

We will create a Data Lake Store account by deploying the following template:

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fvplauzon%2Fazure-training%2Fmaster%2Fiaas-training%2F2.1%20-%20Data%20Lake%20Store%2FADLS.json"
target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fvplauzon%2Fazure-training%2Fmaster%2Fiaas-training%2F2.1%20-%20Data%20Lake%20Store%2FADLS.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

**Note that ADLS is only available in 3 regions**:
* East US 2
* North Europe
* Central US

The template creates an ADLS account within the region of the resource group.  So make sure to select one of those 3 regions for the resource group, otherwise the deployment will fail.

The template contains the following parameters:



Parameter | Description
--- | ---
adlStoreName | Name of the Data Lake Store account to create.  It needs to be globally unique.

## Create Hierarchy

Let's create a hierarchy.

1. Let's open the ADLS resource and select the *Data Explorer*
...![](images/DataExplorer.PNG)
1. Let's create a *New Folder*
![](images/NewFolder.png)
1. Let's call the folder "HR" and click *OK*
1. Let's create two other folders:  "Finance" & "Risk"
1. The folder structure should look like this:
![](images/3Folders.PNG)

## Access Control

Let's give permissions, in the form of Access Control List (ACL) to folders.

1. Select the "Finance" folder
1. Select *Access*
![](images/Access.png)
1. Select *Add*
![](images/Access.png)
1. Select *Select User or Group*
1. In the search box, type the account name of a colleague (or at least a user account present in your Azure Active Directory tenant)
1. Select *Select*
1. Select *Select Permissions*
1. Select *Read*
1. Select *Add to this folder and all children*
![](images/Permissions.PNG)
1. Select *OK*
   

## Notes

By giving read / write permissions to groups (or specific users), we can create governance in the Data Lake.  For instance, a group of users could be responsible to analyse (read) HR data but another one could be responsible to populate the HR data.

## Exercise

Try to script the creation of folders and permissions.

HINT:  use <i>New-AzureRmDataLakeStoreItem</i> and <i>Set-AzureRmDataLakeStoreItemPermission</i>.

## Clean up

Simply delete the resource group where you deploy the Data Lake Store.
