# OS setup guide
This guide assume you already have a minimal install of nixOS and have SSH enabled.
## Step 0
If you are cloning via SSH the first thing that you'll want to do is generate an SSH key and make sure it is connected to your GitHub account.
1. Generate new SSH key:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
2. Add the new SSH key to your GitHub account:
```bash
cat ~/.ssh/id_ed25519.pub
# Then select and copy the contents of the id_ed25519.pub file
# displayed in the terminal to your clipboard
```
3. In the upper-right corner of any page, click your profile photo, then click Settings.
4. In the "Access" section of the sidebar, click SSH and GPG keys.
5. Click New SSH key or Add SSH key.
6. In the "Title" field, add a descriptive label for the new key. For example, if you're using a personal laptop, you might call this key "Personal laptop".
7. Select the type of key, either authentication or signing. For more information about commit signing, see "About commit signature verification."
8. In the "Key" field, paste your public key.
9. Click Add SSH key.
