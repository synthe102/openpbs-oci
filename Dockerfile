FROM rockylinux:8

ARG S6_OVERLAY_VERSION=3.2.0.2

ARG OPENPBS_VERSION=23.06.06

RUN dnf install -y epel-release \
  && crb enable

RUN dnf install -y gcc make rpm-build libtool hwloc-devel libX11-devel libXt-devel libedit-devel libical-devel ncurses-devel perl postgresql-devel postgresql-contrib python3-devel tcl-devel tk-devel swig expat-devel openssl-devel libXext libXft autoconf automake gcc-c++ cjson-devel git wget dnsutils vim procps xz openssh-server

RUN dnf install -y expat libedit postgresql-server postgresql-contrib python3 \
  sendmail sudo tcl tk libical chkconfig cjson

RUN wget "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" -O "/tmp/s6-overlay-noarch.tar.xz" && \
  tar -C / -Jxpf "/tmp/s6-overlay-noarch.tar.xz" && \
  rm -f "/tmp/s6-overlay-noarch.tar.xz"

RUN [ "${TARGETARCH}" == "arm64" ] && FILE="s6-overlay-aarch64.tar.xz" || FILE="s6-overlay-x86_64.tar.xz"; \
  wget "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${FILE}" -O "/tmp/${FILE}" && \
  tar -C / -Jxpf "/tmp/${FILE}" && \
  rm -f "/tmp/${FILE}"

RUN adduser pbs \
  && usermod -aG wheel pbs \
  && sed -i '/^%wheel/c\%wheel ALL=(ALL) NOPASSWD:ALL' /etc/sudoers

USER pbs

WORKDIR /build

RUN wget https://github.com/openpbs/openpbs/archive/refs/tags/v${OPENPBS_VERSION}.tar.gz \
  && tar -xpvf v${OPENPBS_VERSION}.tar.gz

WORKDIR /build/openpbs-${OPENPBS_VERSION}

RUN ./autogen.sh

RUN ./configure --prefix=/opt/pbs

RUN make

RUN sudo make install

RUN sudo /opt/pbs/libexec/pbs_postinstall

RUN sudo chmod 4755 /opt/pbs/sbin/pbs_iff /opt/pbs/sbin/pbs_rcp

COPY start.sh .

ENTRYPOINT ["/init"]

CMD ["./start.sh"]
