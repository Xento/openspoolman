# Deployment options

Run OpenSpoolMan locally, in Docker, or on Kubernetes.

## Local development
- Install dependencies: `pip install -r requirements.txt`.
- Run the app with your configured environment: `python wsgi.py` (supports ad-hoc SSL).

## Docker
- Configure `config.env` with the required environment variables.
- Build or pull the image: `docker pull ghcr.io/drndos/openspoolman`.
- Start using Docker Compose: `docker compose up` (HTTPS requires additional setup in the compose file).
- Multi-arch images (including arm64) are published with v0.1.9; ensure your platform pulls the matching architecture.

## Kubernetes
- Use the provided Helm chart under `helm/`.
- Configure ingress with SSL; reference <https://github.com/truecharts/public/blob/master/charts/library/common/values.yaml> for common options.

## Notes
- Ensure the container or pod can reach both SpoolMan and your Bambu Lab printer.
- If you change the public base URL, NFC tags must be rewritten.
