FROM python:3.12-alpine AS production

RUN apk update && apk upgrade --no-cache && \
    addgroup -g 1001 -S appgroup && \
    adduser -S -G appgroup -u 1001 appuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

USER appuser
EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5000/ || exit 1

CMD ["python", "app.py"]
