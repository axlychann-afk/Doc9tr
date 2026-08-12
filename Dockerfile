FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE Desktop, XRDP, dan kebutuhan lainnya
RUN apt-get update && apt-get install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    sudo \
    && apt-get clean

# Konfigurasi XRDP
RUN adduser xrdp ssl-cert
RUN echo "xfce4-session" > /etc/skel/.xsession

# Buka port RDP
EXPOSE 3389

# Start service
CMD service xrdp start && tail -f /dev/null
