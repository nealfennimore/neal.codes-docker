## Mac installation

Get the latest [Docker mac installer](https://docs.docker.com/docker-for-mac/).
***Docker machine is not used, as we use xhyve instead of virtualbox with this installer***


## Initial install
From root directory run:
```sh
bash scripts/init.sh
```

To build:
```sh
bash build.sh
```

To start:
```sh
bash start.sh
```


## Digital Ocean Setup

Only tested on Ubuntu 16.04. Used with a 512MB Droplet.

```sh
apt install pcregrep

# Add docker user to docker and sudoers group. Update group id to 1000
groupmod docker -g 1000
useradd docker -m -d /home/docker -g docker
usermod -aG sudo docker
passwd docker # Update password to run as sudo

# Enable Firewall
ufw enable
ufw allow OpenSSH
ufw allow ssh
ufw allow http
ufw allow https
ufw limit ssh

# Disable root login
vi /etc/ssh/sshd_config
#PermitRootLogin no

# Create Swap file
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sudo sysctl vm.swappiness=10
echo 'vm.swappiness=10' >> /etc/sysctl.conf

sudo sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf

```