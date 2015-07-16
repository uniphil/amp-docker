#!/bin/bash
set -e
set -u
set -o pipefail

if [ -z "${1-}" ]
then
    echo
    echo "usage: $0 /absolute/path/to/amp/src"
    echo
    exit 1
fi

AMPDIR=$1

if [ ! -d $AMPDIR/TEMPLATE ]
then
    echo
    echo \"$AMPDIR\" does not look like AMP.
    echo Expected to find a folder $AMPDIR/TEMPLATE/
    echo
    exit 1
fi

sudo docker run -i -t\
    -p 8080:8080\
    -v $1:/src\
    -v $(pwd)/.m2:/root/.m2\
    -v $(pwd)/logs:/opt/apache-tomcat-7.0.63/logs\
    amp
