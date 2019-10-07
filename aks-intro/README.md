# Introduction to AKS

This is an introduction demo to [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes) (AKS).  It goes through the main concepts of Kubernetes and how AKS enables integration with Azure resources.

The objective here is just to demystify what AKS is and what usage pattern could look like.  Hopefully this could be a springboard to go and learn more for you.

In your journey with AKS, you might want to consider looking at [my AKS repo](https://github.com/vplauzon/aks).  It's a collection of different deep dive into AKS topics.

For this demo we are going to use the Azure CLI.  This comes in the Azure Cloud Shell and can otherwise be installed in a shell on either Windows / Linux & Mac.

## Demo Map:  Kubernetes' Anatomy

The demo basically follows the different concepts in this map:

![Kubernetes' Anatomy](images/kubernetes-anatomy.png)

By no mean is this Kubernetes' anatomy complete.  There are a lot of concepts we won't cover.  This map focuses on compute concepts, i.e. how to deploy containers and access them.

In this demo, we won't tackle the two top concepts, i.e. Ingress rule & Ingress Controller.

## Container images

We start our journey with container images.

For simplicity, we will not use [Azure Container Registry](https://vincentlauzon.com/2018/05/01/azure-container-registry-getting-started/), which would be a more realistic choice in an Enterprise Context.

Instead, we are going to use [Docker Hub](https://hub.docker.com/).

An image we are going to use a lot is [vplauzon/get-started:part2-no-redis](https://cloud.docker.com/u/vplauzon/repository/docker/vplauzon/get-started).  That name follows Docker's standard:

```
<account name> / <repository name> : <tag>
```

(Where *tag* is optional)

That image is as simple as it gets.  It is based on [Docker's get started tutorial](https://docs.docker.com/get-started/part2/) and code for it can be found [here](https://github.com/vplauzon/containers/tree/master/get-started-no-redis).

In order to play with Docker itself (something we won't do in this demo), the easiest way is to use our [Docker VM Image](https://vincentlauzon.com/2018/04/11/linux-custom-script-docker-sandbox/) which can be deployed from [GitHub here](https://github.com/vplauzon/containers/tree/master/DockerVM).

## Deploying AKS

AKS is available in many regions.  We are going to deploy in East US 2.

First, we are going to determine what is the latest version of Kubernetes available in that region:

```bash
region=eastus2
latestVersion=$(az aks get-versions --location $region --query "orchestrators[-1].orchestratorVersion" -o tsv)
echo "Latest Version is $latestVersion"
```

Then we are going to create a resource group where we are going to deploy AKS:

```bash
rg=aks-demo
az group create --name $rg --location $region
```

Finally, we are going to deploy AKS in that resource group:

```bash
cluster=demo-cluster
az aks create --resource-group $rg --name $cluster -k $latestVersion -s Standard_B2ms --node-count 3 --enable-addons monitoring --generate-ssh-keys --enable-vmss --load-balancer-sku standard
```

The last command will take several minutes to run.

This creates a vanilla cluster with the following characteristics:

* The worker nodes are going to be *Standard B2 ms* ; those are the cheapest that can run AKS at the time of this writing (October 2019)
* There are 3 worker nodes
* It runs the latest version of Kubernetes available in AKS in the deployment region
* It is enabling the *monitoring* add-on
* It runs with VM Scale Sets (VMSS)
* It runs with a *standard load balancer*

Once the cluster is deployed, it is interesting to look at the resource group where it was created.  There should be one resources of type *Kubernetes service*.

Another resource group was created with all the underlying resources (e.g. VMs).  That resource group starts with *MC_* (for *managed cluster*).

## Looking inside the cluster

Before we start pushing workloads on our cluster, let's look at it.

We'll need the *kubectl* CLI.  If it isn't already installed, it can easily be installed with:

```bash
az aks install-cli
```

We then need to connect the CLI to our cluster:

```bash
az aks install-cli
```

Let's look at the nodes:

```bash
kubectl get nodes -o wide
```

There should be three nodes.  Their name corresponds to the VM names in the VMSS.

Let's look at the namespaces:

```bash
kubectl get namespaces
```

Let's look at the pods already running on the cluster:

```bash
kubectl get pods -n kube-system
kubectl get pods -n kube-node-lease
kubectl get pods -n kube-public
kubectl get pods -n default
```

We should see existing pod in the *kube-system* namespace only.

## Single pod

Let's deploy our first pod.  We'll use the spec file [single-pod.yaml](single-pod.yaml).  We'll create a namespace and deploy the pod into it:

```bash
kubectl create namespace single
kubectl apply -f single-pod.yaml -n single
kubectl get pods -n single
```

The last command will display the pod in the newly created namespace.

Although this pod is a web site, we can't access it.  The container is running, but it is unavailable from the outside.

Let's look at more details about that pod:

```bash
kubectl describe pod single-pod -n single
```

Now if we delete the pod and look again:

```bash
kubectl delete pod single-pod -n single
kubectl get pods -n single
```

We see the pod had no persistence.  For that reason, we never create pod this way.

## Deployment

Now let's look at a [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).  Deployments manage replica sets.

We are going to use [simple-deployment.yaml](simple-deployment.yaml):

```bash
kubectl create namespace simple-deployment
kubectl apply -f simple-deployment.yaml -n simple-deployment
kubectl get deployment -n simple-deployment
kubectl get rs -n simple-deployment
kubectl get pods -n simple-deployment
```

We can see the created *deployment*, the *replica set* it manages and the *pods* it manages.  Luckily, we can see the pods in their creation stage.

Let's delete one of the pod (replace *<POD-NAME>* by one of the uniquely named pods):

```bash
kubectl delete pod <POD-NAME> -n simple-deployment
kubectl get pods -n simple-deployment
```

We can see the pod was immediately replaced by another pod.  This was done by the *replica set* which monitors the API Server and always converges to the desired configuration.

Let's delete the *replica set* (replace *<REPLICA-SET-NAME>* by the name of the replica set):

```bash
kubectl delete rs <REPLICA-SET-NAME> -n simple-deployment
kubectl get rs -n simple-deployment
kubectl get pods -n simple-deployment
```

We see the *replica set* is recreated by the deployment.  The underlying pods from the original replica sets are getting terminated while 5 new ones are getting scheduled.

The only way to get rid of the pods is to delete the deployment:

```bash
kubectl delete deploy simple-deployment -n simple-deployment
kubectl get deployment -n simple-deployment
kubectl get rs -n simple-deployment
kubectl get pods -n simple-deployment
```

## Service

Let's deploy a service exposing our pods.

We are going to use [simple-service.yaml](simple-service.yaml):

```bash
kubectl create namespace simple-service
kubectl apply -f simple-service.yaml -n simple-service
kubectl get svc -n simple-service
kubectl get pods -n simple-service
```

We can see the service has two IPs:  internal and external.  The external IP is *pending*.

This is where an Azure integration occur.  If we look back at our *MC_...* resource group, we'll see a new *Public IP* starting with *kubernetes-*.

Eventually the external IP will be provisioned.  If we browse to it, we should see the result of the container's web site.  This should display an *hello world* and display the host name.  The host name is actually the pod name.

Now if we refresh the browser, we should cycle through the 2 pods of the deployment.

Let's redeploy our service with different configuration in [simple-service-v2.yaml](simple-service-v2.yaml).  As a `diff simple-service.yaml simple-service-v2.yaml` would reveal, the difference between the two spec files is the number of pod (v2 has 3) and the v2 overrides an environment variable to change the greeting.

```bash
kubectl apply -f simple-service-v2.yaml -n simple-service
kubectl get pods -n simple-service
```

We can see the API Server detects there were no change to the service and doesn't change it. The pods are terminated and replaced by new ones.

Depending on the timing of the command, we should see an actual *roll out upgrade*, i.e. pods are sequentially created and deleted as opposed to deleting the old ones and then creating new ones.  This way, the service is never down.

If we refresh the browser, we should see the new greeting and we can cycle through the 3 new pods.

## Monitoring

Let's deploy a service we can easily monitor.  We are going to follow [this article](https://vincentlauzon.com/2019/04/02/requests-vs-limits-in-kubernetes/).

We are going to use [monitoring.yaml](monitoring.yaml):

```bash
kubectl create namespace monitoring
kubectl apply -f monitoring.yaml -n monitoring
kubectl get svc -n monitoring
kubectl get pods -n monitoring
```

There are 6 pods with container image [vplauzon/cpu-ram-request-api](https://cloud.docker.com/repository/docker/vplauzon/cpu-ram-request-api).  That is an ASP.NET core application designed to use CPU or RAM on API requests.

First, let's grab the external IP:

```bash
ip=$(kubectl get svc -n monitoring -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
echo "IP:  $ip"
```

(If this doesn't yield an IP, wait 30-60 seconds for the external IP to be provisioned)

Let's try the API:

```bash
curl "http://$ip/"
curl "http://$ip/?duration=90"
curl "http://$ip/?duration=90&core=2"
curl "http://$ip/?duration=15&ram=20"
curl "http://$ip/?duration=15&ram=40"
curl "http://$ip/?duration=15&ram=60"
```

By default (first command), the request lasts for 1 second, using 1 core & 10 Mb of RAM.  We then force the request to take 90 seconds and finally to use two cores.  The last three commands then increase the RAM used by each request.

Those take a little time to run and will take a few minutes to get reflected in the logs as logs aren't collected in real time.

Let's go to Container Insights.  In the Azure Portal, we need to go in the AKS resource (Kubernetes service), under the monitoring heading, we need to select the *Insights* pane.  From there we can select the *Controllers* tab and type *cpu* in the search text box.

![Container Insights](images/container-insights.png)

This should display the *cpu-ram-api-...* replica set.  In time, we should be able to see the CPU spikes on the pods processing the requests.

Let's break the limits of a container by using more than the RAM threshold:

```bash
curl "http://$ip/?duration=15&ram=100"
```

This should return:

```bash
curl: (52) Empty reply from server
```

This is because the spec file enforces a limit of 128 Mb of RAM (including all the overheads, not only the request RAM usage).

In the Insights pane, we'll see the container got recycled.

Those are graphical tools.  We can have access to the underlying raw logs if we go to the *Logs* pane.  This allows us to query the logs using Kusto Query Language (KQL).

# Summary

We did a quick tour around AKS, looking at how we can deploy containers, look at the configuration and monitor them.

This is the tip of the iceberg.  Kubernetes is a very rich ecosystem and we can't cover it in an hour.

Next step could be to look at the [Azure Online Documentation](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes) and dive into scenarios that could be useful for you and / or your organization.