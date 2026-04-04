FROM python:3.11-slim

WORKDIR /app

COPY pyproject.toml .
COPY dockhand_mcp/ ./dockhand_mcp/
COPY README.md .

RUN pip install --no-cache-dir -e .

EXPOSE 8000

CMD ["dockhand-mcp"]
