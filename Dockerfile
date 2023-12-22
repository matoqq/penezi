# Stage 1: Build the environment
FROM python:3.11.4-alpine as builder

# Set poetry variables
ARG YOUR_ENV

ENV YOUR_ENV=${YOUR_ENV} \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100

# Install poetry
RUN pip install poetry==1.5.1

# Set working directory
WORKDIR /app

# Copy poetry items
COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install $(test ${YOUR_ENV} == production && echo "--no-dev") --no-interaction --no-ansi

# Copy scripts (codebase) to folder
COPY . .

# Start server
EXPOSE 8000
CMD ["gunicorn", "app.main:app", "--config=gunicorn_config.py"]
