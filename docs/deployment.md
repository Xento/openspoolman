# Deployment options

OpenSpoolMan can run locally, via Docker Compose, or on Kubernetes with the provided Helm chart.

## Docker Compose
1. Ensure `config.env` is populated (see the setup guide).
2. Start the stack:
   ```bash
   docker compose -f compose.yaml up -d
   ```
3. Access the UI on `http://localhost:8000` (or the host/port you mapped).

## Docker images
- The repository builds multi-architecture images; you can also build locally with `docker build -t openspoolman:local .`.
- Set `OPENSPOOLMAN_BASE_URL` in `config.env` to match the public URL where the container will be served.

## Helm (Kubernetes)
- A starter chart is available under `helm/openspoolman`.
- Populate values for ingress, environment variables, and image registry as needed, then install:
  ```bash
  helm upgrade --install openspoolman helm/openspoolman
  ```

## Running from source
For development, install dependencies and start Flask directly:
```bash
pip install -r requirements.txt
python app.py
```
Use `.env` or `config.env` to supply the same environment variables used in container deployments.
