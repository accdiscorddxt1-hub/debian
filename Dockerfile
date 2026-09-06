FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Thêm kiến trúc i386 cho wine32
RUN dpkg --add-architecture i386

# Cập nhật và cài đặt các gói
RUN apt update && apt install -y \
    xrdp \
    xfce4 \
    xfce4-goodies \
    xorg \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    policykit-1 \
    pulseaudio \
    pulseaudio-utils \
    wine \
    wine32 \
    firefox-esr \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Đặt mật khẩu cho root
RUN echo "root:root" | chpasswd

# Cấu hình X11 cho phép mọi user chạy X
RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config || echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config

# Tạo .xsession để khởi động XFCE
RUN echo "startxfce4" > /root/.xsession && chmod 700 /root/.xsession

# Tạo machine-id cho dbus
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id

# Cấu hình xrdp
RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini && \
    echo "exec startxfce4" > /etc/xrdp/startwm.sh && chmod +x /etc/xrdp/startwm.sh

# Thêm user xrdp vào group ssl-cert để có quyền SSL
RUN adduser xrdp ssl-cert

# Copy script khởi động
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Mở port RDP
EXPOSE 3389

# Chạy script khởi động
CMD ["/start.sh"]
