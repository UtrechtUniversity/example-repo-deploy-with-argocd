# Contributing

Thank you for your interest in contributing to this example application!

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a feature branch (`git checkout -b feature/amazing-feature`)
4. Make your changes
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

## Testing

```bash
# Run health check endpoint
curl http://localhost:8000/health

# Run readiness endpoint
curl http://localhost:8000/ready
```

## Code Style

- Follow PEP 8 conventions
- Keep lines under 100 characters
- Add docstrings to functions

## Deployment

Changes to the `main` branch are automatically deployed:
1. GitHub Actions builds the Docker image
2. Version is bumped automatically
3. ArgoCD syncs every 3 minutes

## Questions?

Feel free to open an issue if you have questions or encounter problems.
