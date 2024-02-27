<div align="center">

# Charts
A collection of Helm Charts for personal projects

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/shini4i)](https://artifacthub.io/packages/search?repo=shini4i)

</div>

## General Information
Add charts repo:
```
helm repo add shini4i https://shini4i.github.io/charts/
```

## Table of Contents
<!-- table_start -->
|                                                 Name                                                |     Type    |                               Description                                | Version | App Version |
|:---------------------------------------------------------------------------------------------------:|:-----------:|:------------------------------------------------------------------------:|:-------:|:-----------:|
|                       [app](https://artifacthub.io/packages/helm/shini4i/app)                       | application |                 A Helm chart for a simple app deployment                 |  0.1.5  |     None    |
|              [argo-watcher](https://artifacthub.io/packages/helm/shini4i/argo-watcher)              | application |                 A Helm chart for deploying argo-watcher                  |  0.6.4  |    v0.8.0   |
|                    [common](https://artifacthub.io/packages/helm/shini4i/common)                    |   library   |             A Helm chart library with some common templates              |  0.0.2  |     None    |
| [mongodb-community-cluster](https://artifacthub.io/packages/helm/shini4i/mongodb-community-cluster) | application | A Helm chart for deploying MongoDBCommunity cluster (community-operator) |  0.2.1  |    6.0.2    |
|          [network-policies](https://artifacthub.io/packages/helm/shini4i/network-policies)          | application |             A generic helm chart for simple network policies             |  0.0.6  |     None    |
|           [node-configurer](https://artifacthub.io/packages/helm/shini4i/node-configurer)           | application |     A Helm chart for making node level configuration during startup      |  0.1.0  |     3.18    |
<!-- table_end -->

## Signing
Starting from `2023-06-11` all charts in this repository are signed with a GPG key. It is done to ensure the integrity of the charts.

To verify the signature, first import the key:
```
gpg --recv-keys F509F29B63C1DC2B
```

Then verify the signature:
```
helm pull shini4i/argo-watcher --version 0.3.1 --prov
helm verify ./argo-watcher-0.3.1.tgz
```

Given that everything is correct, you should see the following output:
```
Signed by: Vadim Gedz <vadims@linux-tech.io>
Using Key With Fingerprint: FF1E9948F6234DC6D70AB47BF509F29B63C1DC2B
Chart Hash Verified: sha256:66555b4f6ac47a4ff67beb20963e6bd3ffcb0a8a1c33bfd8bba1d89011b0355a
```
