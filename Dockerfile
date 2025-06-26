# Stage 1: Build with dependencies
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install build tools for compiling packages
RUN apk add --no-cache gcc musl-dev libffi-dev

# Install Python dependencies to a target directory
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools>=78.1.1 \
 && pip install --no-cache-dir -r requirements.txt -t /app

# Copy application code
COPY app.py .

# Stage 2: Minimal runtime image
FROM python:3.11-alpine AS final

WORKDIR /app

# Ensure vulnerable preinstalled setuptools is upgraded
RUN pip install --no-cache-dir --upgrade setuptools>=78.1.1 \
 && find /usr/local/lib/python3.11/site-packages/ -name 'setuptools-65.5.1.dist-info' -exec rm -r {} +

# Copy dependencies and application from builder
COPY --from=builder /app /app

CMD ["python", "app.py"]
