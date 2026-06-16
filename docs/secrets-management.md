# 🔐 Secrets Management with SOPS and Age

This repository uses **[SOPS](https://github.com/getsops/sops)** (Secrets OPerationS) combined with **[Age](https://github.com/FiloSottile/age)** and the **[sops-nix](https://github.com/Mic92/sops-nix)** module to manage sensitive data like API keys, passwords, and environment variables declaratively.

Instead of keeping plain-text secrets in your git repository, SOPS encrypts the values while keeping the YAML keys readable. `sops-nix` then securely decrypts them during system activation and loads them into `/run/secrets/`.

---

## 1. Initial Setup: Generating an Age Key

`Age` is a modern, simple alternative to GPG. You need to generate a private key on your machine to decrypt the secrets.

1. Create the directory for your keys:
   ```bash
   mkdir -p ~/.config/sops/age
   ```
2. Generate the key:
   ```bash
   age-keygen -o ~/.config/sops/age/keys.txt
   ```
   *Note: This command will print your **Public Key** to the terminal. It will look something like `age1...`*

3. **Backup your private key:** The `keys.txt` file contains your private identity. Back it up to a secure password manager or offline storage. If you lose this key, you lose access to decrypt the repository's secrets!

---

## 2. Configuring `.sops.yaml`

The `.sops.yaml` file at the root of this repository maps which public keys are allowed to decrypt which files. 

If you are adding a new machine or a new key, you must add its public key to this file:

```yaml
# .sops.yaml
keys:
  - &sintra_phantom age1your_public_key_here
  - &sintra_wraith age1another_public_key_here
creation_rules:
  - path_regex: secrets.yaml$
    key_groups:
    - age:
      - *sintra_phantom
      - *sintra_wraith
```

### Adding a New Machine (Multi-Key Setup)

If `secrets.yaml` was already created on another machine (e.g., `phantom`) using its own `age` key, your new machine (e.g., `wraith`) **will not be able to decrypt it** until the original machine grants it access.

Here is the exact process to authorize a new machine:

1. **On the NEW machine:** Generate the `age` key as shown above and copy the **Public Key**.
2. **On the ORIGINAL machine:** 
   * Open `.sops.yaml` and add the new machine's public key to the file.
   * Add the new reference to the `creation_rules` block.
   ```yaml
   keys:
     - &sintra_phantom age1original_key_here
     - &sintra_wraith age1newly_generated_public_key_here
   creation_rules:
     - path_regex: secrets.yaml$
       key_groups:
       - age:
         - *sintra_phantom
         - *sintra_wraith
   ```
3. **On the ORIGINAL machine:** Run the following command:
   ```bash
   sops updatekeys secrets.yaml
   ```
   *(This tells SOPS to decrypt the file with the old key, and re-encrypt it to include the new key).*
4. **On the ORIGINAL machine:** Commit and push the updated `.sops.yaml` and `secrets.yaml` to Git.
5. **On the NEW machine:** `git pull`. Your new machine can now successfully decrypt `secrets.yaml`!

---

## 3. Editing Secrets

To create or edit a secrets file, use the `sops` command. Because `.sops.yaml` is in the root directory, SOPS knows exactly which keys to use for encryption.

```bash
sops secrets.yaml
```

* **What happens:** SOPS decrypts the file into a temporary buffer, opens it in your default terminal editor (`$EDITOR`), and automatically re-encrypts it when you save and exit.
* **If it opens in the wrong editor:** You can temporarily override it:
  ```bash
  EDITOR=nano sops secrets.yaml
  ```

### Adding New Secrets
Inside `secrets.yaml`, you write standard YAML:
```yaml
hermes-env: |
  GEMINI_API_KEY=AIzaSy...
  OPENAI_API_KEY=sk-...
```

---

## 4. Using Secrets in NixOS

This repository uses `sops-nix` to securely inject these secrets into your system configuration without putting them in the world-readable `/nix/store`.

In `/system/sops.nix`, we configure the global settings:
```nix
sops = {
  defaultSopsFile = ../secrets.yaml;
  age.keyFile = "/home/sintra/.config/sops/age/keys.txt";
  
  # Declare the secrets we want to deploy to the system
  secrets."hermes-env" = { format = "yaml"; };
};
```

When you rebuild your system (`just switch`), `sops-nix` decrypts the secret and places it at `/run/secrets/hermes-env` with strict permissions.

You can then pass the path to this secret into systemd services. For example, in `/system/hermes.nix`:
```nix
services.hermes-agent = {
  enable = true;
  # ...
  environmentFiles = [ config.sops.secrets."hermes-env".path ];
};
```
