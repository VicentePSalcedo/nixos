# Security Rules

- **Never decrypt `secrets.yaml`**: The agent must never decrypt or attempt to view/decrypt the `secrets.yaml` file (specifically using the `sops -d secrets.yaml` command or any other decryption commands).
