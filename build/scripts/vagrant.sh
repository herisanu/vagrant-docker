#!/bin/sh

# Store build time
date > /etc/vagrant_box_build_time

# add vagrant user
useradd -m vagrant || true


# Set up sudo
mkdir -p /etc/sudoers.d
touch /etc/sudoers.d/vagrant
echo "" > /etc/sudoers.d/vagrant
echo 'Defaults:vagrant !requiretty' >> /etc/sudoers.d/vagrant
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
echo "Defaults:vagrant env_keep += SSH_AUTH_SOCK" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Install vagrant key
mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
#wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

mkdir -pm 700 /root/.ssh
cp /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys
chown -R root:root /root/.ssh

echo 'root:vagrant' | chpasswd
echo 'vagrant:vagrant' | chpasswd
