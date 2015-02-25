#!/bin/bash

if [ -d /mnt/host_proc ]; then
  umount /proc
  mount -o bind /mnt/host_proc /proc
fi

exec $@

