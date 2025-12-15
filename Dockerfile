FROM python:3.6
WORKDIR /app
RUN echo "Hello from Fedora Quadlets!" > index.html
CMD ["python3", "-m", "http.server", "8000"]
