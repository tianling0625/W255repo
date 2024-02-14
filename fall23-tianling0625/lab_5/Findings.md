# Lab 5 Findings - [Tianyu Wang]

- [Lab 5 Findings - [Tianyu Wang]](#lab-5-findings---Tianyu Wang)
  - [Introduction](#introduction)
  - [Findings](#findings)
    - [Finding 1](#finding-1)
    - [Finding 2](#finding-2)
    - [Finding 3](#finding-3)
    - [Finding 4](#finding-4)
    - [Finding 5](#finding-5)
  - [Conclusion](#conclusion)

---

## Introduction

Latency and cache rate are two important metrics to evaluate the performance of a web service. In this lab, I will use the `load.js` script to simulate the user request and collect the metrics of http req duration, cache rate, CPU usage and other metrics. The `load.js` script will send requests to the web service with different cache rate and record the metrics. The cache rate is set from 0 to 1. The results will be monitored by prometheus and visualized by grafana.

## Findings

Below are the findings from the experiment.

### Finding 1

Original random intiger from 0 to 19 might cause some error due to the constrain condition from the main.py file as the room number is require to be larger than 0. Issue was fixed by updating the random range to [1,20] in the load.js file.

![Finding 1](/lab_5/image1.png)

### Finding 2

Geographical location has a significant impact on the http req duration. I'm currently stay in China and the P95 http req duration is larger than 300ms. However, when I use the AWS EC2 instance in the US, the P95 http req duration is less than 100ms.
![Finding 2](/lab_5/image2.png)

### Finding 3

Higher Cache rate leads to lower request duration . As the cache rate increase from 0 to 1, the metric of incoming request duration decrease.
![Finding 3](/lab_5/image3.png)

### Finding 4

Higher Cache rate leads to lower CPU usage. As the cache rate increase from 0 to 1, the metric of CPU usage decrease as well. (Please ignore the peaks in the middle part due to EC2 disconnecting issue.)
![Finding 4](/lab_5/image4.png)

### Finding 5

All of the response codes are 200, which means all of the requests are successfully processed. There are some code 503 from the lower cache rate, might due to the high request rate.
![Finding 5](/lab_5/image5.png)

## Conclusion

In this lab, I used the `load.js` script to simulate the user request and collect the metrics of http req duration, cache rate, CPU usage and other metrics. The cache rate is set from 0 to 1. The results show that higher cache rate leads to lower request duration and CPU usage. The geographical location also has a significant impact on the http req duration. The P95 http req duration is larger than 300ms in China, but less than 100ms in the US. All of the response codes are 200, which means all of the requests are successfully processed. There are some code 503 from the lower cache rate, might due to the high request rate.
