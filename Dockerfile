# Stage 1: Base - install dependencies with Poetry
FROM python:3.13-slim-bookworm AS base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y curl build-essential && rm -rf /var/lib/apt/lists/*

# Install Poetry using its official installer
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

RUN mkdir -p /code
WORKDIR /code

# Copy Poetry config and install dependencies
COPY pyproject.toml poetry.lock /code/
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# Copy application code
COPY ./src /code/src

# Stage 2: Production - minimal runtime image
FROM base AS production

# Copy external dependencies and installed packages
COPY --from=base /code /code
WORKDIR /code

# Production command for FastAPI
CMD ["fastapi", "run", "src/main.py", "--port", "80"]
