#!/bin/bash

trap ctrl_c SIGINT

function ctrl_c() {
  sudo /etc/init.d/pbs stop
}

if [[ -z ${UPDATE_PBS_CONF} || ${UPDATE_PBS_CONF} == "true" ]]; then
  sudo sed -i "/PBS_SERVER/c\PBS_SERVER=$HOSTNAME" /etc/pbs.conf
  sudo sed -i '/PBS_START_MOM/c\PBS_START_MOM=1' /etc/pbs.conf
fi

sudo /etc/init.d/pbs start & sleep infinity
