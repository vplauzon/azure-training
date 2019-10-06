# Introduction to AKS

This is an introduction demo to AKS.  It goes through the main concepts of of Kubernetes and how AKS enables integration with Azure resources.

In your journey with AKS, you might want to consider looking at [my AKS repo](https://github.com/vplauzon/aks).  It's a collection of different deep dive into AKS topics.

For this demo we are going to use the Azure CLI.  This comes in the Azure Cloud Shell and can otherwise be installed in a shell on either Windows / Linux & Mac.

## Demo Map:  Kubernetes' Anatomy

The demo basically follow the different concepts in this map:

![Kubernetes' Anatomy](images/kubernetes-anatomy.png)

By no mean is this Kubernetes' anatomy complete.  There are a lot of concepts we won't cover.  This map focuses on compute concepts, i.e. how to deploy containers and access them.

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

First we are going to determine what is the latest version of Kubernetes available in that region:

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

This creates a vanila cluster with the following characteristics:

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

There should be three nodes.  Their name correspond to the VM names in the VMSS.

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

Let's deploy our first pod.  We'll use the spec file [single-pod.yaml](single-pod.yaml):

```bash
```
