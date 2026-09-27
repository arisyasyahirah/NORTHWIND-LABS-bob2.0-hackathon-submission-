# Instance: Northwind Labs (fictional demo)

Overlay on the generic pipeline. Everything client-specific lives here; the core (`scripts/`, `.bob/`, `mcp/`, `PIPELINE.md`) is never edited for a client.

- `instance.yaml`: prefill for intake (company, brand, repo URL, project folder, roles dir).
- `company/`, `roles/`, `hires/`: source material and sample hire.
- `demo-videos/`: sample generated output.

Run: `/onboard @instances/northwind-labs/instance.yaml @instances/northwind-labs/hires/alex-tan.yaml`
New client: copy this folder to `instances/<client>/`, edit `instance.yaml`.
