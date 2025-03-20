FROM rockylinux:8

RUN dnf install -y epel-release \
  && crb enable
RUN dnf install -y gcc make rpm-build libtool hwloc-devel libX11-devel libXt-devel libedit-devel libical-devel ncurses-devel perl postgresql-devel postgresql-contrib python3-devel tcl-devel tk-devel swig expat-devel openssl-devel libXext libXft autoconf automake gcc-c++ cjson-devel git wget dnsutils

RUN dnf install -y expat libedit postgresql-server postgresql-contrib python3 \
  sendmail sudo tcl tk libical chkconfig cjson

RUN adduser pbs \
  && usermod -aG wheel pbs \
  && sed -i '/^%wheel/c\%wheel ALL=(ALL) NOPASSWD:ALL' /etc/sudoers

USER pbs

WORKDIR /build

RUN wget https://github.com/openpbs/openpbs/archive/refs/tags/v23.06.06.tar.gz \
  && tar -xpvf v23.06.06.tar.gz

WORKDIR /build/openpbs-23.06.06

RUN ./autogen.sh

RUN ./configure --prefix=/opt/pbs

RUN make

RUN sudo make install

RUN sudo /opt/pbs/libexec/pbs_postinstall

RUN sudo chmod 4755 /opt/pbs/sbin/pbs_iff /opt/pbs/sbin/pbs_rcp

COPY start.sh .

CMD [ "./start.sh" ]
