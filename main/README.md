# README

Welcome to W255 Machine Learning Systems Engineering. The goal of this class is for you to be comfortable with what a production environment might look like for a real-time machine learning API, and additionally to be bootstrapped for any capstone project that requires some similar level of concern.

The Syllabus can be found here: [Syllabus](https://drive.google.com/file/d/1pOOKK0zyUt_KrNjrMctUs686tezYbVcQ/view)

This repository over-rides the Syllabus concerning due dates.

## Grading

Grading for this class is meant to be informative. We expect people to work in teams and learn from eachother collective. We also expect students to submit their own work; knowing it won't be without information potentially gained from other students. The instructional team does not care whether you work together with your classmates, we care whether you learn how to create, manage, and communicate about a real production environment with other key stakeholder groups such as IT, Operations, DevOps, Software Engineering, etc.

### Mastery-Based Grading

For this class we will be doing Mastery-Based grading. This means we break scores into 4 buckets `100`, `90`, `50`, or `0`.

Here is how you can interpret these scores:

- `100`: everything is perfect
- `90`: everything is good, except maybe some minor details
- `50`: solid attempt was made, but missed the boat on what we're trying to accomplish (most grading systems would give this less than 50)
- `0`: You did not attempt to solve the problem and/or it showed closed to no effort

## Projects & Labs

Labs are under the labs folder. Labs will be provided as we transition through each lab.

Project will be provided in week 9 as we transition towards Kubernetes.

### Due Dates

- Lab 1: Sep 19
- Lab 2: Oct 10
- Lab 3: Oct 31
- Lab 4: Dec 5
- Lab 5: Dec 12
- Project: Dec 16

### Connecting to Azure and AKS

#### Azure Subscription

Subscription ID for the semester: `0257ef73-2cbf-424a-af32-f3d41524e705`

This is a note to make it easy for us to update each semester. Anywhere you see [SUBSCRIPTION] use the subscription ID above.

#### How to connect to our Azure Kubernetes Cluster

1. Install Azure CLI `az`
   1. <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli>
2. Install `kubectl`
   1. <https://kubernetes.io/docs/tasks/tools/>
3. Install `kubelogin`
   1. <https://github.com/Azure/kubelogin>
4. Accept W255 Azure AD Domain invitation
   1. These will be sent to your `@berkeley.com` email
   2. These will be sent out near the end of lab 3 typically
5. `az login --tenant berkeleydatasciw255.onmicrosoft.com`
   1. Use your `@berkeley.com` email
6. `az account set --subscription="[SUBSCRIPTION]"`
7. `az aks get-credentials --name w255-aks --resource-group w255`
8. `export PREFIX=$(az account show | jq ".user.name" |  awk -F@ '{print $1}' | tr -d "\"" | tr -d "." | tr '[:upper:]' '[:lower:]')` (get your email prefix dynamically)
   1. <winegarj@berkeley.edu> -> winegarj
   2. <test.123@berkeley.edu> -> test123
   3. <Upper.123@berkeley.edu> -> upper123
9. `echo $PREFIX`
   1. This should be lowercase version of your email with periods removed
10. `kubectl run nginx-dev --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine --namespace $PREFIX`
11. This will confirm whether you have access to the cluster
12. `kubectl get pods --namespace $PREFIX`
    1. Tets for whether you can see the running container in your namespace
13. `kubectl delete --all pods --namespace=$PREFIX`
14. `kubectl run nginx-dev --image=mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine --namespace default`
    1. Tests for access in the default namespace which you should not have
    2. Will fail for no api access

#### How to see resources in Azure

1. Accept the invitation in above first
2. <https://portal.azure.com>
3. Login with your @berkeley.com email
4. Click top right corner for user menu dropdown
5. Click Switch Directory
6. Switch to W255 directory or berkeleydatasciw255.onmicrosoft.com domain
7. <https://portal.azure.com/#@berkeleydatasciw255.onmicrosoft.com/>

## Readings

Below are all of the readings for the class. Please read before the associated synchronous class session; however, reading ahead will be beneficial for the class as we get towards the more hands-on 2nd half.

### Supporting Technology to Review

In this seciton we provide training and reading resources for supporting technologies we will be using in this class. There is an expectation that you will learn these tools on an as needed basis to faciliate your work in the class.

Particularly you will need to be or become comfortable with the following:

- `bash`
- `git`
- `python`
  - `FastAPI`
  - `Pydantic`
- `docker`
- Rest API fundamentals

#### Bash

- [Bash Tutorial](https://www.codecademy.com/learn/learn-the-command-line)
- [Command-line Tools can be 235x Faster than your Hadoop Cluster](https://adamdrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html)

#### Git

- [Pro Git - Book](https://git-scm.com/book/en/v2)
- [Web-based Scenerios for Git](https://www.katacoda.com/courses/git)
- [GitHub Actions Devops (Course 1-> 4)](https://lab.github.com/githubtraining/devops-with-github-actions)

#### FastAPI

- [Official Tutorial](https://fastapi.tiangolo.com/tutorial/)
  - [Testing](https://fastapi.tiangolo.com/tutorial/testing/)
  - [Error Handling](https://fastapi.tiangolo.com/tutorial/handling-errors/)
  - [Response Model](https://fastapi.tiangolo.com/tutorial/response-model/)
- [realpython.com Tutorial](https://realpython.com/fastapi-python-web-apis/)

#### Docker

- [Docker-Curriculum Tutorial](https://docker-curriculum.com/)
- [Official Docker Tutorial](https://docs.docker.com/get-started/)
- [Multi-stage Builds for Python](https://gabnotes.org/lighten-your-python-image-docker-multi-stage-builds/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

#### RestAPI

- [API Architecture — Best Practices for designing REST APIs](https://link.medium.com/daB4HtnUEmb)
- [Mozilla - HTTP response status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

### Week 1 (Monolith and Microservice Architectures)

- [Decision Points for Microservice vs. Monolith](https://microservices.io/articles/applying.html)
- [Bounded Context - Martin Fowler](https://martinfowler.com/bliki/BoundedContext.html)
- [Database per Microservice Pattern](https://microservices.io/patterns/data/database-per-service.html)
- [Microservices vs. Monoliths: An Operational Comparison](https://thenewstack.io/microservices-vs-monoliths-an-operational-comparison/)
- [How we broke up our Monolithic Django Service into microservices](https://medium.com/greedygame-media/how-we-broke-up-our-monolithic-django-service-into-microservices-8ad6ff4db9d4)
- [What I understand about domain-driven design](https://medium.com/code-thoughts/what-i-understand-about-domain-driven-design-f7fbd00e364f)
- [Representing entities in (micro)services](https://medium.com/code-thoughts/representing-entities-in-micro-services-b8aad8e7b835)
- [Django at Instagram (Video)](https://www.youtube.com/watch?v=lx5WQjXLlq8)

### Week 2 (Continuous Integration and Continuous Deployment)

- [Gitlab - CI/CD concepts](https://docs.gitlab.com/ee/ci/introduction/)
- [Martin Fowler - Continuous Delivery](https://martinfowler.com/bliki/ContinuousDelivery.html)
- [Martin Fowler - Testing Strategies in a Microservice Architecture](https://martinfowler.com/articles/microservice-testing/)
- [GitHub Actions Review](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)
- [Data Drift in Review](https://evidentlyai.com/blog/ml-monitoring-data-drift-how-to-handle)
- [Google MLOps: Continuous delivery and automation pipelines in machine learning](https://cloud.google.com/architecture/mlops-continuous-delivery-and-automation-pipelines-in-machine-learning)
- [AWS MLOps](https://docs.aws.amazon.com/solutions/latest/aws-mlops-framework/architecture-overview.html)
- [Azure MLOps](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python)

### Week 3 (Development and Production Systems)

- [FastAPI Docker](https://fastapi.tiangolo.com/deployment/docker/#fastapi-in-containers-docker)
- [Azure Databricks Analytics Platform](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture)
- [AWS Databricks Analytics Platform](https://databricks.com/blog/2020/06/12/enterprise-cloud-service-public-preview-on-aws.html)
- [Data Lake on GCP](https://cloud.google.com/architecture/build-a-data-lake-on-gcp)

### Week 4 (Machine Learning over an API, Part I)

- [Batch vs Real-Time Processing](https://www.confluent.io/learn/batch-vs-real-time-data-processing/)
- [Batch is a Special Case of Streaming](https://www.ververica.com/blog/batch-is-a-special-case-of-streaming)
- [Serve a machine learning model using Sklearn, FastAPI and Docker](https://medium.com/analytics-vidhya/serve-a-machine-learning-model-using-sklearn-fastapi-and-docker-85aabf96729b) [Do not do a Request model like this]
- [Productionizing Machine Learning: From Deployment to Drift Detection](https://databricks.com/blog/2019/09/18/productionizing-machine-learning-from-deployment-to-drift-detection.html)
- [Machine Learning Service for Real-Time Prediction](https://towardsdatascience.com/machine-learning-service-for-real-time-prediction-9f18d585a5e0)

### Week 5 (Machine Learning over an API, Part II)

- [Minimizing real-time prediction serving latency in machine learning](https://cloud.google.com/architecture/minimizing-predictive-serving-latency-in-machine-learning)

### Week 6 (Caching)

- [Caching API with Redis and Node](https://codeburst.io/caching-api-with-redis-and-node-b6f76831b442)

### Week 7 (State Management)

- [Stateful vs. Stateless Architecture Overview](https://www.bizety.com/2018/08/21/stateful-vs-stateless-architecture-overview/)
- [Stateful vs. Stateless Architecture: Why Stateless Won](https://www.virtasant.com/blog/stateful-vs-stateless-architecture-why-stateless-won)

### Week 8 (Kubernetes, Part I - Kubernetes Introduction, Abstraction, and Deployments)

- [Introduction to Kubernetes architecture](https://www.redhat.com/en/topics/containers/kubernetes-architecture)
- [Key Kubernetes Concepts](https://towardsdatascience.com/key-kubernetes-concepts-62939f4bc08e)

### Week 9 (Kubernetes, Part II - Services, Ingress, and Service Mesh)

- [Kubernetes Documentation - Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Kubernetes Services simply visually explained](https://medium.com/swlh/kubernetes-services-simply-visually-explained-2d84e58d70e5)
- [How DNS Works](https://howdns.works/)
- [How DNS Works - Different View](https://www.digitalocean.com/community/tutorials/an-introduction-to-dns-terminology-components-and-concepts)
- [What is a Domain Name](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/What_is_a_domain_name)

### Week 10 (Kubernetes, Part II - Monitoring, Security, & Opinionated Frameworks)

- [What's a service mesh?](https://www.redhat.com/en/topics/microservices/what-is-a-service-mesh)
- [What is Istio?](https://istio.io/v1.1/docs/concepts/what-is-istio/)
- [Istio's Architecture](https://istio.io/latest/docs/ops/deployment/architecture/)
- [Istio Security Concepts](https://istio.io/latest/docs/concepts/security/)

### Week 11 (Deploy and Instrument a Machine Learning API)

- [Minimizing real-time prediction serving latency in machine learning](https://cloud.google.com/architecture/minimizing-predictive-serving-latency-in-machine-learning)

### Week 12 (Model Evaluation)

- [Productionizing Machine Learning: From Deployment to Drift Detection](https://github.com/joelcthomas/modeldrift)

### Week 13 (Security)

- [A Case Study of the Capital One Data Breach (Revised)](http://web.mit.edu/smadnick/www/wp/2020-16.pdf)
- [Why ninety-day lifetimes for certificates?](https://letsencrypt.org/2015/11/09/why-90-days.html)

## Async Notes

Week 2:

- Web Servers (uvicorn, gunicorn, etc.)

Week 5:

- 5.2 is incorrect. need to address column ordering into the API. Flask does not have a built-in serialization framework like FastAPI with pydantic. Probably need to use Marshmallow.

Week 6:

- Deserialization/Serialization (short video)

Week 8:

- Desired State (short video)

Week 9:

- Setting up Nodeport for a simple application
- Setting up LoadBalancer for a simple application

Week 8/9/10:

- Add more diagrams

Week 10:

- k6 load test on bookstore
