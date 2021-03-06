# Use this file with:
# source <(curl -Ls https://raw.githubusercontent.com/simplerick0/ansible-arch/main/seed.sh)
echo "Downloading SSH Key"
install -m 700 -d /root/.ssh
github_username="simplerick0"
curl -s "https://api.github.com/users/${github_username}/keys" | python -c 'import json,sys;print(json.load(sys.stdin)[3]["key"])' > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "Starting SSH"
systemctl enable --now sshd

echo "Arch Ready to be Installed"
