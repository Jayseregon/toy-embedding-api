FROM python:3.13.2-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies needed for building packages
RUN apt-get update && apt-get install -y curl build-essential && rm -rf /var/lib/apt/lists/*

# Install Poetry using its official installer
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

RUN mkdir -p /code
WORKDIR /code

# Copy project configuration and install dependencies with Poetry
COPY pyproject.toml poetry.lock /code/
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# Remove build tools and caches to shrink the image while preserving installed packages
RUN apt-get purge -y --auto-remove build-essential && \
    rm -rf /root/.cache

# Copy application source code
COPY ./src /code/src

EXPOSE 10000

# Change the CMD to use uvicorn with PORT env variable
CMD ["sh", "-c", "uvicorn src.main:app --host 0.0.0.0 --port ${PORT:-10000}"]

# # Change the CMD to use uvicorn with PORT env variable
# CMD poetry run uvicorn src.main:app --host 0.0.0.0 --port $PORT
