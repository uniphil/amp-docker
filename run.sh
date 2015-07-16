#!/bin/bash
sudo docker run -i -t\
    -p 8080:8080\
    -v $1:/src\
    -v $(pwd)/.m2:/root/.m2\
    -v $(pwd)/logs:/opt/apache-tomcat-7.0.63/logs\
    amp
