FROM python:3.14-slim
WORKDIR /app
COPY requirements.txt .
COPY . .
RUN pip install --no-cache-dir -r requirements.txt \
    && useradd --create-home appuser \
    && chown -R appuser:appuser /app
USER appuser
CMD ["python", "main.py"]
