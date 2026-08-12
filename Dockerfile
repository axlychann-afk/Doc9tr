FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH, Curl, Wget, dan Cloudflare WARP
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    gnupg \
    gpg \
    lsb-release \
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ jammy main" | tee /etc/apt/sources.list.d/cloudflare-client.list \
    && apt-get update && apt-get install -y cloudflare-warp \
    && apt-get clean

# Setup SSH
RUN mkdir -p /var/run/sshd
RUN echo 'root:axly12341' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

# Start warp-svc di background, tunggu 5 detik, daftar, konek, baru nyalain SSH
CMD bash -c "warp-svc & sleep 5 && warp-cli --accept-tos registration new && warp-cli --accept-tos connect && /usr/sbin/sshd -D"
