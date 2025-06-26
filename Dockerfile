# Stage 1 - build dependencies
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --target=/app/deps -r requirements.txt

COPY app.py .

# Stage 2 - production image (distroless)
FROM gcr.io/distroless/python3

WORKDIR /app

COPY --from=builder /app/deps /app
COPY --from=builder /app/app.py /app

CMD ["app.py"]
