This playbook is for personal use on my Lenovo X1 Carbon (6th Gen). There are likely things that 
need to be tweaked (like device names, mine is an NVMe) so use carefully.  This is also set up for 
booting with UEFI. If you can't do that, you'll need to lookup GRUB or some other bootloader.

Initial Setup:
* You need an archiso install disk: https://archlinux.org/download/
  * If you configure it with cloud-init as described here: https://wiki.archlinux.org/title/Install\_Arch\_Linux\_via\_SSH you can skip the networking and seed script steps.
* Check to make sure Secure Boot is disabled (TODO: Implement secure boot compatibility after install)
* Boot to USB via UEFI and start the Arch Installer
* Enable networking. If running on WiFi (iwctl device list):
  * `iwctl station wlan0 connect <wifi_ssid>`
  * This will prompt for your wifi passphrase and store the passphrase and PSK at:
    `/var/lib/iwd/<wifi_ssid>.psk`
* Download the seed script and run it. This will pull down you SSH Public Key from your github account
  * `source <(curl -Ls https://raw.githubusercontent.com/simplerick0/ansible-arch/main/seed.sh)`
  * NOTE: The API endpoint lists your keys in the order they appear on the settings page.  Make
    sure to update the index in the python command to select the right one.
  * Also update your username in the script.

Create a Vault Password File:
* `echo "<vault_password>" > vault.txt`

Copy Vault Sample Files and Update Accordingly:
* `cp group\_vars/vault_sample group_vars/vault`
* `cp group\_vars/arch_laptop/vault_sample group_vars/arch_laptop/vault`

Encrypt Your Vaults:
* `ansible-vault encrypt --vault-id vault.txt group_vars/vault`
* `ansible-vault encrypt --vault-id vault.txt group_vars/arch_laptop/vault`

Create Inventory File (e.g.):
* `echo "laptop" > inventory`
* Alternatively, update `/etc/ansible/hosts`

Update the Playbook Hosts if Needed in `playbook.yaml`

Run the Playbook
* `ansible-playbook -i inventory --vault-id vault.txt playbook.yaml -e 'ansible_user=root skip_cleanup=yes skip_reboot=yes'`
  * Add `-K` to prompt for sudoer password if you are running the playbook on a post-install boot.
  * You also can omit the `-e 'ansible_user=root'` to use the new user instead of root.
  * NOTE: The playbook checks for the hostname to determine if it should recreate disk partitions.
    If the hostname is 'archiso', the `install_arch` role will be included.
  * TODO: Make sure playbook can run from localhost to do dev of the playbook on the machine

Credit to: https://github.com/antoinemartin/archlinux-ansible-install
