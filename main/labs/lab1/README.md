# Lab 1: Containerizing a Basic API

<p align="center">
    <!--FAST API-->
        <img src="https://user-images.githubusercontent.com/1393562/190876570-16dff98d-ccea-4a57-86ef-a161539074d6.svg" width=10%>
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=10%>
    <!--POETRY LOGO-->
        <img src="https://python-poetry.org/images/logo-origami.svg" width=7%>
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=10%>
    <!--DOCKER-->
        <img src="https://user-images.githubusercontent.com/1393562/209759111-3e98226d-d2ed-47c1-85c4-c96c7a3fbf3b.svg" width=12%>
</p>

- [Lab 1: Containerizing a Basic API](#lab-1-containerizing-a-basic-api)
  - [Lab Objectives](#lab-objectives)
  - [Lab Setup](#lab-setup)
    - [Working Repository](#working-repository)
    - [Python Dependency Management: Poetry](#python-dependency-management-poetry)
    - [Creating your lab package with Poetry](#creating-your-lab-package-with-poetry)
  - [Lab Requirements](#lab-requirements)
    - [Dependency Management](#dependency-management)
    - [API Development](#api-development)
    - [Testing and Quality Assurance](#testing-and-quality-assurance)
    - [Application Containerization](#application-containerization)
    - [Run Script](#run-script)
    - [Documentation](#documentation)
  - [Example Final Folder Structure](#example-final-folder-structure)
  - [Submission](#submission)
  - [Grading](#grading)
  - [Helpful Tips](#helpful-tips)
    - [Why Python 3.10](#why-python-310)
    - [Frameworks and Opinionated Systems](#frameworks-and-opinionated-systems)
    - [Adding Dependencies with Poetry](#adding-dependencies-with-poetry)
    - [Running commands from the poetry virtual environment](#running-commands-from-the-poetry-virtual-environment)
    - [.gitignore](#gitignore)
    - [Testing Tips](#testing-tips)
  - [Time Expectations](#time-expectations)

---

## Lab Objectives

1. Build a `FastAPI` application that supports the endpoints described in the [Requirements section](#lab-requirements).
1. Test your API's functionality using `pytest`
1. Manage your project dependencies with `poetry`
1. Create a `Dockerfile` which uses multi-stage builds to package and run your application
1. Design a bash script `run.sh` which demonstrates your application working as a containerized application.
1. Document your work with a `README.md` for how to build, run, and test code in the app root directory.
1. Answer several short answer questions (2-3 sentences) to help solidify your understanding of this lab.

## Lab Setup

### Working Repository

You should have a repo in [GitHub](https://github.com/orgs/UCB-W255/) with a name following the following standard `[TERM][YEAR]-[GITHUB_USERNAME]`. For example: <https://github.com/UCB-W255/fall23-jameswinegar>. All work for all labs and projects should be done in this repository with the following folder structure:

```text
.
└── lab_1
└── lab_2
└── lab_3
└── lab_4
└── lab_5
└── project
```

You do not need to manage pull requests, etc. Instructors and TAs will pull down code when they go to grade.
Submission timelines are on the honor system, but we will be grading quickly to provide meaningful feedback.
Due dates are based on the ones posted in the main Github repo; any updates to these will be signaled via Slack channels if necessary.

### Python Dependency Management: Poetry

Throughout the class, we will follow the opinionated structure that is put together by the [python poetry](https://python-poetry.org/) package. You will need to install this tool on your machine by [following the instructions](https://python-poetry.org/docs/#installation). Make sure to **follow all instructions, including adding poetry to your PATH**.

It's best not to use other `python` management systems simultaneously (i.e., do not activate an anaconda environment and then create a poetry environment within the other).

### Creating your lab package with Poetry

Once you have installed `poetry`, you can use the following command from within your `lab_1` folder to create a boilerplate project structure.

```{bash}
poetry new lab1 --name src
```

This will add a folder similar to the following:

```text
.
└── lab_1
   └── lab1
      ├── README.md
      ├── poetry.lock
      ├── pyproject.toml
      ├── src
      │   ├── __init__.py
      │   └── main.py
      └── tests
         ├── __init__.py
         └── test_src.py
└── lab_2
└── lab_3
└── lab_4
└── lab_5
└── project
```

Poetry is intended to manage any external packages which you may use for your application. [Check out the documentation for more tips.](https://python-poetry.org/docs/basic-usage/)

## Lab Requirements

We have listed the requirements of the lab in the logical order you should approach it.

### Dependency Management

- [ ] Use `poetry` to initialize and manage your development environment and package dependencies
  - [ ] Add the following as dependencies
    - `Python 3.10`
    - `FastAPI`
    - `Uvicorn`
  - [ ] Add the following as development dependencies
    - `pytest`
    - `httpx`
    - `ruff`
    - `black`

### API Development

- [ ] Create a `FastAPI` application with the following constraints:
  - [ ] `/hello` endpoint
    - [ ] takes a query parameter `name`
    - [ ] Returns a properly formatted JSON string of

        ```{json}
        {
          "message": "hello [VALUE]"
        }
        ```

        where `[VALUE]` is the user's inputted query parameter `name`.
  - [ ] Your application should raise an error if the query parameter `name` is not specified and send an appropriate HTTP status code to the client
  - [ ] `/` endpoint
    - [ ] Returns `Not Found` to the requester.
    - Your application should raise an HTTP exception and send the appropriate HTTP status code to the client
    - You do not necessarily have to implement this yourself
  - [ ] `/docs` endpoint
    - [ ] browsable while API is running
    - [ ] Serves the corresponding OpenAPI documentation
  - [ ] `/openapi.json`
    - [ ] browsable while API is running
    - [ ] returns a `json` object that meets the OpenAPI specification version `3+`

### Testing and Quality Assurance

Utilize `pytest`-based testing to create the following test suites **including but are not limited to**:

- [ ] Test that all endpoints respond correctly to the right inputs
- [ ] Test that all endpoints respond correctly to the incorrect inputs
- [ ] Test the endpoints with a variety of values.
- [ ] Any other tests that you believe will demonstrate that your API is functioning as needed

### Application Containerization

Containerize your application with Docker:

- [ ] Utilize a multi-stage `Dockerfile` build to reduce image sizes
  - [Follow this tutorial to create a multistage build with Poetry](https://gabnotes.org/lighten-your-python-image-docker-multi-stage-builds/)
  - *Note*: This tutorial is not perfect. Leverage what you learn in class for your implementation.
  - Follow `Dockerfile` best practices for reducing image sizes concern `apt` cache, `pip` cache, ordering of `COPY` commands, etc. [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [ ] Your executed docker container has the API hosted and accessible on port `8000` on your local machine
- [ ] Do not use `poetry run [COMMAND]` for the final `CMD` of your docker container, especially when using multi-stage builds where you are isolating your build requirements from your runtime requirements.
  - [Deploying FastAPI with Docker](https://fastapi.tiangolo.com/deployment/docker/#fastapi-in-containers-docker)

### Run Script

Create a `run.sh` bash script in the `lab1` root that will do the following with descriptive `echo` statements for each step you are taking:

- [ ] Build your docker container (name it something useful)
- [ ] Run your built container in detached mode `-d` so that script can continue
- [ ] [curl](https://curl.se/) the defined endpoints and return status codes (non-exhaustive examples below):

   ```bash
   echo "testing '/hello' endpoint with ?name=Winegar"
   curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name=Winegar"

   echo "testing '/' endpoint"
   curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/"

   echo "testing '/docs' endpoint"
   curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/docs"
   ```

- If your application works properly, it should return the appropriate codes

- [ ] Kill the running container after the tests
- [ ] Delete the built docker container

### Documentation

Document your work in a well-formatted `README.md` within the `lab1/` directory.

- [ ] You should describe how to do the following:
  - [ ] What your application does
  - [ ] How to build your application
  - [ ] How to run your application
  - [ ] How to test your application

- [ ] In a separate section, answer the following questions
  - [ ] What status code should be raised when a query parameter does not match our expectations?
    - [HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) might be a good reference
  - [ ] What does Python Poetry handle for us?
  - [ ] What advantages do multi-stage docker builds give us?

## Example Final Folder Structure

The file placement is directional, we do not care where exactly your `run.sh` is for example as long as it works and makes sense. `python` has an expected structure for packages, and `poetry` helps layout that structure.

```{text}
.
└── .gitignore
└── lab_1
   ├─── run.sh
   └─── lab1
      ├── Dockerfile
      ├── README.md
      ├── src
      │   ├── __init__.py
      │   └── main.py
      ├── poetry.lock
      ├── pyproject.toml
      └── tests
         ├── __init__.py
         └── test_lab1.py
├── lab_2
├── lab_3
├── lab_4
├── lab_5
└── project
```

## Submission

All code will be graded off your repo's `main` branch. No additional forms or submission processes are needed.

## Grading

|        **Criteria**        |         **0%**          |                                     **50%**                                     |                                 **90%**                                  |                              **100%**                              |
| :------------------------: | :---------------------: | :-----------------------------------------------------------------------------: | :----------------------------------------------------------------------: | :----------------------------------------------------------------: |
|     **Functional API**     |    No Endpoints Work    |                            Some Endpoints Functional                            |                        Most Endpoints Functional                         |                          All Criteria Met                          |
|    **Docker Practices**    |      No Dockerfile      | Dockerfile exists but is not functional or does not fit criteria (i.e., multistage) | Dockerfile fulfills most requirements but does not follow best practices |                          All Criteria Met                          |
|        **Testing**         |   No Testing is done    |                         Minimal amount of testing done                          |             Only "happy path" tested and with minimal cases              |                          All Criteria Met                          |
|       **Run Script**       |  No Run Script exists   |            Run Script is not functional or missing key requirements             |                   Run Script missing some requirements                   |                          All Criteria Met                          |
|     **Documentation**      | No Documentation exists |                             Very weak documentation                             |                   Documentation missing some elements                    |                          All Criteria Met                          |
| **Short-Answer Questions** | No Questions Attempted  |                          Minimal or incorrect answers                           |    Mostly well thought through answers but may be missing some points    | Clear and succinct answers that demonstrate understanding of topic |

## Helpful Tips

### Why Python 3.10

Python 3.10 allows us to use native `python` types instead of the `typing` library.
For your project, you should do the following:

- ✅ use

   ```python
   def method(item: int | str):
   ```

- ❌ do not use

   ```python
   from typing import Union
   def method(item: Union[int, str]):
   ```

### Frameworks and Opinionated Systems

Throughout the class, we will be using a REST API framework - [FastAPI](https://fastapi.tiangolo.com/). We can set the expectation that the framework will handle some of our concerns.

As you review the [Lab Requirements](#lab-requirements) keep this in mind: ***Try to keep everything as simple as possible while achieving the goals.***

### Adding Dependencies with Poetry

The Poetry framework allows for external dependencies to be added in different groups to help better control which packages will be necessary for your specific type of work.

In our case, we want to separate our development dependencies (typically known as dev dependencies) from our production dependencies (typically known as prod dependencies).

Poetry defines the production dependencies as those that are in the "main" dependency group, this is implicitly defined in the `pyproject.toml` file.
All of the development dependencies should go with the `dev` group.

[Review the documentation for how Poetry defines to properly organize your `dev` group for all version of Poetry since version `1.2.0`](https://python-poetry.org/docs/managing-dependencies/#dependency-groups)

### Running commands from the poetry virtual environment

Follow the guide here to [install Poetry on your machine](https://python-poetry.org/docs/master/#installing-with-the-official-installer)
You should also read up on the [basic usage of Poetry](https://python-poetry.org/docs/basic-usage/).

`poetry` allows you to run scripts directly from its environment in a controlled fashion:

```bash
poetry run uvicorn main:app --reload
```

This will run the [uvicorn](https://www.uvicorn.org/) application within the context of the virtual environment created by poetry without having to source/activate the environment.

You can also activate the virtual environment within your shell by running the `poetry shell` command; this will allow your to run all your commands directly within your shell without needing to preempt each command with `poetry run`.

### .gitignore

Add a `.gitignore` file to the root of your repo with the following:

<https://github.com/github/gitignore/blob/main/Python.gitignore>

### Testing Tips

You should be able to utilize `poetry` to run `pytest` through the command `poetry run pytest`.
Your testing scripts should be in the directory generated by `poetry`.
[FastAPI has a great testing tutorial you should read.](https://fastapi.tiangolo.com/tutorial/testing/)

## Time Expectations

| Previous Experience                                        | Time Estimate |
| ---------------------------------------------------------- | ------------- |
| Background with Docker, API Development, Poetry, Git, etc. | 2-4 hours     |
| Background with Git + API Development in Python or Docker  | 8 hours       |
| No prerequisite background                                 | 20-30 hours   |
