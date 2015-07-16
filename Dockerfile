FROM ubuntu:trusty
RUN apt-get update && apt-get -y upgrade
ENV dbname=amp\
    tomcat=apache-tomcat-7.0.63\
    dump=dump.pgsql

# normal OS applications
RUN apt-get install -y\
    curl\
    maven\
    nodejs\
    npm\
    openjdk-7-jdk

# set up monetdb
WORKDIR /var
COPY files/monetdb.list /etc/apt/sources.list.d/monetdb.list
RUN curl https://www.monetdb.org/downloads/MonetDB-GPG-KEY | apt-key add - &&\
    apt-get update &&\
    apt-get install -y monetdb5-sql monetdb-client
RUN monetdbd create dbfarm &&\
    monetdbd start dbfarm &&\
    monetdb create ${dbname} &&\
    monetdb release ${dbname} &&\
    monetdbd stop dbfarm

# set up postgres
WORKDIR /opt
COPY ${dump} files/dev-db.sql ./
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&\
    apt-get update && apt-get install -y\
    python-software-properties\
    software-properties-common\
    postgresql-9.3\
    postgresql-client-9.3\
    postgresql-contrib-9.3\
    postgresql-9.3-postgis-2.1
RUN sed -i 's/\(local *all *postgres *\)peer/\1trust/' /etc/postgresql/9.3/main/pg_hba.conf &&\
    sed -i 's/\(host *all *all *127.0.0.1\/32 *\)md5/\1trust/' /etc/postgresql/9.3/main/pg_hba.conf &&\
    service postgresql start &&\
    createuser -U postgres amp &&\
    createuser -U postgres amp_query &&\
    createdb   -U postgres -w --template template0 --encoding UTF8 $dbname &&\
    pg_restore -U postgres -w -d $dbname ${dump} || true &&\
    psql       -U postgres -w -d $dbname -f dev-db.sql &&\
    service postgresql stop &&\
    rm ${dump}

# set up tomcat
RUN curl -O http://apachemirror.ovidiudan.com/tomcat/tomcat-7/v7.0.63/bin/${tomcat}.tar.gz &&\
    curl -O https://www.apache.org/dist/tomcat/tomcat-7/v7.0.63/bin/${tomcat}.tar.gz.asc &&\
    gpg --keyserver pgpkeys.mit.edu --recv-key D63011C7 &&\
    gpg --verify ${tomcat}.tar.gz.asc ${tomcat}.tar.gz &&\
    tar -zxf ${tomcat}.tar.gz
RUN sed -i '2i JAVA_OPTS="$JAVA_OPTS -server -Xmx3650m -XX:MaxPermSize=512m -Djava.awt.headless=true\
        -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false\
        -Dorg.apache.jasper.compiler.Parser.STRICT_WHITESPACE=false"' ${tomcat}/bin/catalina.sh &&\
    rm -r ${tomcat}/webapps/ROOT &&\
    ln -s /src ${tomcat}/webapps/ROOT
COPY files/context.xml files/tomcat-users.xml ${tomcat}/conf/

# get ready
COPY files/run-amp.sh ./
RUN mkdir -p /src
EXPOSE 8080
ENTRYPOINT ["bash", "/opt/run-amp.sh"]
