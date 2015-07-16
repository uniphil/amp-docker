#!/bin/bash
set -e
set -u
set -o pipefail

# build
cd /src
mkdir -p /src/WEB-INF/lib/
mvn clean generate-resources process-resources\
    -DserverName=local -Djdbc.db=${dbname}\
    -Djdbc.user=postgres -Djdbc.password=none

# init services
cd /var
monetdbd start dbfarm
service postgresql start

# run
cd /opt
${tomcat}/bin/startup.sh
tail -f ${tomcat}/logs/catalina.out
