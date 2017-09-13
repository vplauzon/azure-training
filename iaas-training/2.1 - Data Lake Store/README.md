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

<ol>
    <li>
        <p>
            Let's open the ADLS resource and select the <i>Data Explorer</i>
        </p>
        <p>
            <img src="https://github.com/vplauzon/azure-training/raw/master/iaas-training/2.1%20-%20Data%20Lake%20Store/images/DataExplorer.PNG" />
        </p>
    </li>
    <li>
        <p>
            Let's create a <i>New Folder</i>
        </p>
        <p>
            <img src="https://github.com/vplauzon/azure-training/raw/master/iaas-training/2.1%20-%20Data%20Lake%20Store/images/NewFolder.PNG" />
        </p>
    </li>
    <li>
        Let's call the folder "HR" and click <i>OK</i>
    </li>
    <li>
        Let's create two other folders:  "Finance" & "Risk"
    </li>
    <li>
        <p>
            The folder structure should look like this:
        </p>
        <p>
            <img src="https://github.com/vplauzon/azure-training/raw/master/iaas-training/2.1%20-%20Data%20Lake%20Store/images/3Folders.PNG" />
        </p>
    </li>
</ol>

## Access Control

## Notes

## Exercise

## Clean up

