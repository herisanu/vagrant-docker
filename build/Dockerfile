
FROM centos/systemd

MAINTAINER "Your Name" <you@example.com>

ENV container docker

COPY scripts /opt/build/scripts

RUN yum -y install sudo openssh-server openssh-clients net-tools; \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key; \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key; \
    systemctl enable sshd; \
    /opt/build/scripts/vagrant.sh; \
    rm -f /etc/nologin; \
    rm -f /var/run/nologin; \
    rm -f /run/nologin; \
    sed -i '/pam_loginuid/s/required/optional/' /etc/pam.d/sshd; \
    echo "UseDNS no" >> /etc/ssh/sshd_config; \
    sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers; \
    rm -rf /opt/build; 

VOLUME [ "/sys/fs/cgroup" ]

CMD /usr/lib/systemd/systemd --system

