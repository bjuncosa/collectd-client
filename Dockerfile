FROM ubuntu:trusty
MAINTAINER Borja Juncosa <borja.juncosa@socialpoint.es>

ENV TMP_PACKAGES="build-essential wget librrd-dev"

WORKDIR /usr/src
RUN apt-get update && \
    apt-get install -y $TMP_PACKAGES && \
    wget https://collectd.org/files/collectd-5.4.1.tar.gz && \
    tar xzf collectd-5.4.1.tar.gz && \
    cd collectd-5.4.1 && \
    ./configure --prefix=/usr/local --disable-daemon \
      --enable-cpu \
      --enable-df \
      --enable-disk \
      --enable-exec \
      --enable-interface \
      --enable-load \
      --enable-logfile \
      --enable-memory \
      --enable-network \
      --enable-processes \
      --enable-rrdtool \
      --enable-swap \
      --enable-users \
    && \
    make && \
    make install && \
    mkdir -p /var/lib/collectd/rrd && \
    apt-get remove -y --purge $TMP_PACKAGES && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /usr/src/collectd*

RUN apt-get install -y rrdtool

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd collect

ADD collectd/collectd.conf.d/* /etc/collectd/collectd.conf.d/
ADD collectd-docker.sh /var/lib/collectd/
ADD collectd-docker.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/collectd-docker.sh
ADD collectd/collectd.conf /etc/collectd/

ADD 20_collect_sudo /etc/sudoers.d/
RUN chmod 0440 /etc/sudoers.d/20_collect_sudo

ADD start.sh /usr/local/bin/start.sh
RUN chmod a+x /usr/local/bin/start.sh
ENTRYPOINT [ "/usr/local/bin/start.sh" ]

CMD ["/usr/local/sbin/collectd", "-C", "/etc/collectd/collectd.conf"]

