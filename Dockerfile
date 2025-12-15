FROM python:3.9-slim
WORKDIR /app
RUN echo "Hello from Fedora Quadlets!" > index.html
CMD ["python3", "-m", "http.server", "80"]
