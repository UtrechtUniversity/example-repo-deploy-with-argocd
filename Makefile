.PHONY: help install dev test docker-build docker-push clean

help:
	@echo "Available commands:"
	@echo "  make install      - Install dependencies"
	@echo "  make dev          - Run development server"
	@echo "  make test         - Run application tests"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-push  - Push Docker image to registry"
	@echo "  make clean        - Clean up temporary files"

install:
	pip install -r requirements.txt

dev:
	python app.py

test:
	python -c "import sys; sys.path.insert(0, '.'); from app import app; \
		client = app.test_client(); \
		assert client.get('/').status_code == 200; \
		assert client.get('/health').status_code == 200; \
		assert client.get('/ready').status_code == 200; \
		print('✅ All tests passed')"

docker-build:
	docker build -t example-app:latest .

docker-push: docker-build
	@echo "Set REGISTRY and IMAGE_NAME environment variables before pushing"
	docker tag example-app:latest $${REGISTRY}/$${IMAGE_NAME}:latest
	docker push $${REGISTRY}/$${IMAGE_NAME}:latest

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .coverage htmlcov
