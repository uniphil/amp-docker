#!/bin/bash
set -e
set -u
set -o pipefail

if [ ! -f dump.pgsql ]
then
    echo could not find the database dump \"dump.pgsql\"
    exit 1
fi

sudo su -c 'time docker build -t amp .'
