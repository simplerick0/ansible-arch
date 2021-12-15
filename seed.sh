echo "Downloading SSH Key"
install -m 700 -d /root/.ssh
github_username="simplerick0"
curl -s "https://api.github.com/users/${github_account}/keys" | python -c 'import json,sys;print(json.load(sys.stdin)[2]["key"])' >/root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "Starting SSH"
systemctl enable --now sshd

echo "Arch Ready to be Installed"
