#!/bin/bash

trap ctrl_c SIGINT

function ctrl_c() {
  sudo /etc/init.d/pbs stop
}

sudo /etc/init.d/pbs start & sleep infinity
