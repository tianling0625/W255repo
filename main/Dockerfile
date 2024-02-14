FROM mcr.microsoft.com/devcontainers/python:3

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install curl wget

ENV KUBELOGIN_RELEASE="v0.0.32" \
    POETRY_VERSION="1.6.1" \
    POETRY_HOME=/etc/poetry

RUN wget -O /tmp/kubelogin.zip "https://github.com/Azure/kubelogin/releases/download/${KUBELOGIN_RELEASE}/kubelogin-linux-amd64.zip" && \
    unzip /tmp/kubelogin.zip -d /usr/local/bin && \
    rm /tmp/kubelogin.zip

RUN curl -sSL https://install.python-poetry.org | python -
ENV PATH $POETRY_HOME/bin:$PATH
