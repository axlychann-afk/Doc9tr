FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH dan dependensi utama
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Buat direktori runtime SSH
RUN mkdir -p /var/run/sshd

# Set password root (ganti 'passwordlu' dengan password yang diinginkan)
RUN echo 'root:axly12341' | chpasswd

# Konfigurasi SSH agar menerima login password & root
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

# Jalankan SSH Daemon di foreground agar container tidak exit
CMD ["/usr/sbin/sshd", "-D"]
