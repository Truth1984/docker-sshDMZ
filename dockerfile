
FROM centos:8

# install

RUN yum install -y nano net-tools curl redhat-lsb-core epel-release sudo supervisor
RUN yum install -y openssh-server openssh-clients iptables fail2ban

# prep

COPY util.sh util.sh
RUN chmod 777 util.sh && ./util.sh setup
RUN ssh-keygen -A

# pre-def
RUN ./util.sh password 14 1 > DMZ_PASSWORD
ENV DMZ_USER=root

## 5 times / 1 hour
ENV DMZ_BANTIME=3600 
ENV DMZ_MAXRETRY=5

# process

RUN id -u ${DMZ_USER} &>/dev/null || useradd ${DMZ_USER}
RUN echo "${DMZ_USER}:$(cat DMZ_PASSWORD)" | chpasswd
RUN mkdir -p /etc/fail2ban
RUN printf "[DEFAULT]\nbantime = ${DMZ_BANTIME}\nmaxretry = ${DMZ_MAXRETRY}\nbanaction = iptables-multiport\n\n[sshd]\nenabled = true\n" > /etc/fail2ban/jail.local

RUN : \
    ; mkdir /etc/systemd/system/sshd-keygen.service.d \
    ; { echo "[Install]"; echo "WantedBy=multi-user.target"; } \
    > /etc/systemd/system/sshd-keygen.service.d/enabled.conf

RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# end
RUN rm util.sh

# EXPOSE 22

CMD ["/usr/bin/supervisord"]