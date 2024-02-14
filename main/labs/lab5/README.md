# Lab 5: Understanding Metrics and Performance Indicators

<p align="center">
    <!--KUBERNETES-->
        <img src="https://user-images.githubusercontent.com/1393562/190876683-9c9d4f44-b9b2-46f0-a631-308e5a079847.svg" width=10%>
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=10%>
    <!--Azure-->
        <img src="https://user-images.githubusercontent.com/1393562/192114198-ac03d0ef-7fb7-4c12-aba6-2ee37fc2dcc8.svg" width=10%>
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=10%>
    <!--K6-->
        <img src="https://user-images.githubusercontent.com/1393562/197683208-7a531396-6cf2-4703-8037-26e29935fc1a.svg" width=10%>
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=10%>
    <!--GRAFANA-->
        <img src="https://user-images.githubusercontent.com/1393562/197682977-ff2ffb72-cd96-4f92-94d9-2624e29098ee.svg" width=10%>
</p>

- [Lab 5: Understanding Metrics and Performance Indicators](#lab-5-understanding-metrics-and-performance-indicators)
  - [Lab Overview](#lab-overview)
  - [Lab Objectives](#lab-objectives)
  - [Helpful Information](#helpful-information)
    - [K6 Documentation](#k6-documentation)
    - [Accessing Grafana](#accessing-grafana)
    - [Networking Requirements](#networking-requirements)
    - [Writeup](#writeup)
  - [Expected Final Folder Structure](#expected-final-folder-structure)
  - [Submission](#submission)
  - [Grading](#grading)
  - [Time Expectations](#time-expectations)

## Lab Overview

The goal of `lab_5` is to performance test your application which has been deployed on `Azure Kubernetes Service (AKS)`.

You will:

- Use `K6` to load test your `/bulk_predict` endpoint
- Use the `Prometheus` Time Series Database (TSDB) to capture metrics from `istio` proxy sidecars
- Use `Grafana` to visualize these metrics using `istio`'s prebuilt dashboards

Additionally, the following have been handled for you automatically:

- Metrics capture for `istio` proxy sidecars using a `Prometheus` `ServiceMonitor`
- `Grafana` Dashboards built by the `istio` team for visualization of data captured by various `ServiceMonitors` for `workloads` (`Deployments`/`StatefulSets`) and `services`.
- `Kiali` for visualization of network traffic within the cluster.
- DNS (`{namespace}.midsw255.com` using `external-dns`)
- TLS Cert (Let's encrypt certs generated using `cert-manager`)
- HTTP -> HTTPS redirection `istio-gateway`
- Istio Gateway for DNS `istio-gateway`

## Lab Objectives

- [x] Deploy your `lab4` solution to Kubernetes. Your application should already be deployed to `AKS` from `lab4` if it is not then redeploy `lab4`.
- [ ] [Install `K6` on your local machine](https://k6.io/docs/getting-started/installation/)
- [ ] Modify your API (or the `load.js` file we provided) to support your endpoint's schema
- [ ] Extend the `load.js` to send payloads to your `/bulk_predict` endpoint correctly
- [ ] Run your `K6` script against your `/bulk_predict` endpoint
- [ ] Show the difference in performance with different `CACHE_RATE`s between `[0,1]`
- [ ] Capture screenshots of your `grafana` dashboard for your service/workload during the execution of your `k6` script
- [ ] Document all of your findings in a separate document `Findings.md`
- [ ] All images are embedded and visible in your `Findings.md`

## Helpful Information

### K6 Documentation

`K6` is an open-source load balancing tool that we will be using to test our system under a variety of conditions with fantastic documentation. Before you start the project, [review the following link to understand how k6 works](https://k6.io/docs/getting-started/running-k6/).

Most of the time, you will be running the following command: `k6 run load.js`. Review the script that we provide and understand how it operates; describing what the script is doing will be imperative for your submission.

### Accessing Grafana

`Grafana` is an open-source graphing tool that we will be using to visualize time series information that comes from our deployments. We will host the instance of `Grafana`, so you will not need to install or configure it. You will need to port-forward from the AKS cluster our `grafana` to your `localhost` to get access. Use the following command:

```bash
kubectl port-forward -n prometheus svc/grafana 3000:3000
```

***This grafana instance is shared across the entire class. Do not make edits/save to dashboards that we have provided to you.*** You should utilize the variable selection portions to make sure your deployment can be analyzed, but you will never need to change any of the existing dashboards or create new ones.

### Networking Requirements

Because `K6` is creating a bevy of requests locally from your machine, it is important to have a system which can support that. Consider the following:

- Running the script from within a Virtual Machine (VM) on your ***local*** machine will not be viable as the VM will have limited access to your network hardware. This is because, typically, virtual NICs do not provide full access to the bandwidth available to the system.
- Running the script with poor network connectivity will reduce the quality of the load test and not be a representative sample of your system.
- If you run into issues, you can spin up a VM in a cloud provider that will have enough bandwidth to stress the endpoint.

If you find yourself with either of these or similar classes of problems, consider utilizing a cloud VM (AWS EC2, Azure VM, Digital Ocean Droplet, Linode VM, etc.), which will not have any networking problems.

### Writeup

We have provided you a template document, `Findings.md`, *that in no way is meant to be filled exactly*. You should consider it as a starting point that you will then use to craft the narrative about the difference in performance and what you can see based on the variety of variables, KPIs, and other metrics that are available to you.

You should be capturing screenshots as evidence of your findings and using them in your point, making sure to embed them directly in the document so they are viewable from the Github markdown viewer. They should be screenshots that are in your repo, not directly uploaded to Github's CDN servers.

Your writing style should be professional and from the point of view of a report to a manager about the difference in performance.

Your submission should only be a markdown file. [Consider this guide from Github about writing Github "flavored" markdown files.](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

## Expected Final Folder Structure

```{text}
.
├── .gitignore
├── lab_1
├── lab_2
├── lab_3
├── lab_4
└── lab_5
    ├── README.md
    ├── Findings.md
    ├── image_1.png
    ├── image_2.png
    ├── ...
    ├── image_n.png
    └── load.js
└── project
```

## Submission

All code will be graded off your repo's `main` branch. No additional forms or submission processes are needed.

## Grading

|   **Criteria**   |    **0%**    |                    **50%**                     |                         **90%**                          |                                                     **100%**                                                      |
|:---------------: |:-----------: |:---------------------------------------------: |:-------------------------------------------------------: |:----------------------------------------------------------------------------------------------------------------: |
|     *Narrative*  | No Write Up  | Some discussion about performance differences  | Well-described understanding of performance differences  | Demonstrated full understanding of metrics and performance differences with concise and understandable narrative  |
| *Linked Images*  | No Images    | Images Uploaded to Github                      | N/A                                                      | All Images embedded directly in Markdown Document                                                                 |

## Time Expectations

This lab will take approximately ~4-6 hours. Most of the time will be spent running your `k6` script and reviewing `grafana` dashboards.
