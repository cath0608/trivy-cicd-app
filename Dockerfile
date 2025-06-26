# First stage: build with dependencies
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install build tools
RUN apk add --no-cache gcc musl-dev libffi-dev

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t /app

# Copy application code
COPY app.py .

# Final stage: runtime image
FROM python:3.11-alpine

WORKDIR /app

# Copy installed dependencies and app
COPY --from=builder /app /app

CMD ["python", "app.py"]
