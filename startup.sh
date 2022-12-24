#!/bin/bash
set -eou pipefail

./startup2.sh &

chown root:kvm /dev/kvm
service libvirtd start
service virtlogd start
VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up

exec "$@"
