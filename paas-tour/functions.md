# Azure Functions

[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview) is a serverless compute service.

One of the strenght of Azure Functions is its bindings.  It allows the function runtime to bind different Azure services.

We will implement a function which is triggered when a file is dropped in Blob Storage and push the content to Cosmos DB.  The code doesn't have any reference to neither Blob Storage nor Cosmos DB SDKs.  The connection to those services is assumed by the Function runtime.

First, let's open the function resource:

![Functions resource](images/functions/function-resource.png)

1. Let's hover next to *Functions* and click the **+** button:
![New Function](images/functions/new-function.png)
1. Let's click the hyperlink *create your own custom function*:
![Custom Function](images/functions/create-custom.png)
1. Let's select the *Blob trigger* box *C#* link:
![Blob Trigger](images/functions/blob-trigger.png)
1. Let's fill the form as follow:
   * In *Name*, type *BlobToCosmos*
   * In *Path*, type *input/{name}*
   * Leave *Storage account connection* as is
1. Click Create
![New Function Form](images/functions/new-function-form.png)
1. Let's select *Integrate* menu option:
![Integrate menu](images/functions/integrate-menu.png)
1. Here we see that the trigger & input is blob storage
1. Let's add an output:  click *New Ouptut*
![New Output](images/functions/new-output.png)
1. Let's select *Azure Cosmos DB* and click *Select*
1. Let's fill the form as follow:
   * Check the *Use function return value* box
   * As *Database name*, enter *mydb*
   * As *Collection Name*, enter *mycoll*
   * Check the *If true, creates the Azure Cosmos DB database and collection* box
   * In *Azure Cosmos DB account connection*, click *new*
     * Make sure your susbscription is selected
     * Select the Cosmos DB created for this demo
     * Click Select
1. Click *Save*
![New Output Form](images/functions/new-connection-form.png)
1. Let's go back to the code by clicking on *BlobToCosmos*
![Back to code](images/functions/back-to-code.png)
1. We should see the following error
![Error](images/functions/return-error.png)
This is normal as the current code doesn't have a return type and therefore can't be bound
1. Let replace the code by the following:
    ```
    #r "Newtonsoft.Json"

    using Newtonsoft.Json;

    public static async Task<object> Run(Stream myBlob, string name, TraceWriter log)
    {
        using (var reader = new StreamReader(myBlob))
        {
            var blobText = await reader.ReadToEndAsync();
            var blobObject = JsonConvert.DeserializeObject(blobText);
            
            log.Info($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
            log.Info($"Blob content:  {blobText}");

            return new
            {
                fileName = name,
                processedBy = "Function",
                content = blobObject
            };
        }
    }
    ```
1. We can observe there are no Blob or Cosmos DB SDK references:
    * The blob comes as input with the type *System.IO.Stream*, a standard .NET type
    * The returned document is a Plain Old .NET Object (POCO)
1. Hit *Save*
1. Let's add a blob container named *input* on the storage account within the resource group.  We can use either using the Portal or [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/).  The name, *input*, is important as we just configure our function to monitor that container.

We now have all the pieces in place.  We can test our function.

1. Let's open Cosmos DB Data Explorer in the documents of the *mycoll* collection of *mydb* database
    * We recommend to do this in a different tab to keep the function tab open in order to observe the logs
1. We can prepare to refresh the document list by hitting the refresh button
![Watch documents](images/functions/documents.png)
1. Let's go to this [GitHub folder](https://github.com/vplauzon/azure-training/tree/master/paas-tour/test-blobs), pick the file [a.json](https://github.com/vplauzon/azure-training/blob/master/paas-tour/test-blobs/a.json) and drop it in the *input* blob container
1. After a few seconds we should observe the following in the function logs:
![Logs](images/functions/logs.png)
1. In Cosmos DB we should observe that a document has been inserted:
![Document A](images/functions/document-a.png)
1. Hence we see that our function took the JSON content of the file, added some properties (*fileName* & *processedBy*) and inserted the resulting document in Cosmos DB
1. We can drop all the other files in the blob container

The binding in Azure Functions make it very easy to integrate different Azure services together.

Also the Serverless nature of Azure Functions makes it easy to focus on the business logic and let Azure worry about scaling issues.