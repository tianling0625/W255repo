## Build stage
FROM python:3.10-slim as build

# add curl
RUN apt-get update \
    && apt-get upgrade -y\
    && apt-get install curl -y \
    && rm -rf /var/lib/apt/lists/*

# install poetry
ENV POETRY_VERSION="1.6.1"
ENV POETRY_HOME="/opt/poetry"
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH=${POETRY_HOME}/bin:$PATH

# Copy lock and toml files
COPY pyproject.toml poetry.lock ./
# Create virtual environment
RUN python3 -m venv /app/venv --copies
# Activate virtual environment
RUN . /app/venv/bin/activate \
    && poetry install --only main

## Deploy stage
FROM python:3.10-slim as deploy
COPY --from=build /app/venv /app/venv

# Copy the rest of the files
COPY . .
# Run the application
CMD ["/app/venv/bin/uvicorn", "src.main:app", "--host", "0.0.0.0"]