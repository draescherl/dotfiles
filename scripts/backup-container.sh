#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Please specify a container name" >&2
	exit 2
fi
bin=/usr/bin/machinectl
$bin stop $1
$bin export-tar $1 /home/lucas/Downloads/$1.$(date +%F_%T).tar.xz
$bin start $1
