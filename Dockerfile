FROM python:3.10.13-alpine3.19

WORKDIR /app

RUN adduser -D python && chown -R python /app

COPY src ./src
COPY poetry.lock poetry.lock
COPY pyproject.toml pyproject.toml

USER python:python
RUN pip install poetry
RUN poetry install --no-root

CMD ["poetry run", "uvicorn main:app --reload"]