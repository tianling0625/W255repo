FROM python:3.10-slim-buster

RUN apt-get update \
  && apt-get install -y \
       curl build-essential \
  && rm -rf /var/lib/apt/lists/*


ENV POETRY_VERSION=1.1.13
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH /root/.local/bin:$PATH

WORKDIR /app
COPY pyproject.toml poetry.lock ./

RUN python -m venv --copies /app/venv
RUN . /app/venv/bin/activate && poetry install --no-dev

COPY . ./

CMD ["/app/venv/bin/python", "-c", "import docker; print(docker.__version__)"]
