How to run it
=============

```docker run -ti -d \
  --privileged \
  --volume=/:/rootfs:ro \
  --volume=/proc:/mnt/host_proc:ro \
  --volume=/sys:/sys:ro \
  --volume=/tmp/rrd:/var/lib/collectd/rrd:rw \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --name=<host-hostname> \
  --hostname=<host-hostname> \
  bjuncosa/collectd-client
```

To configure the right server to send the data, you can mount a volume on /etc/collectd/collectd.conf.d/network.conf with the right configuration.
