AMP on Docker
=============

Run a local development copy of AMP in a Docker container with minimal fuss.

![Screenshot of an AMP dev setup](screenshot.png)


Prerequisites
-------------

- [ ] Linux (not yet tested on Mac or Windows -- might work?)
- [ ] Docker
- [ ] A copy of AMP 2.10 or 2.11 source code
- [ ] A database dump from an AMP install


Setup
-----

1. Clone this repository somewhere on your system
2. Copy your database dump into this repo as `dump.pgsql`
3. Run [`./build.sh`](build.sh). Get coffee. Maybe lunch. This takes a while.


Run
---

1. Run [`./run.sh /path/to/amp/checkout`](run.sh)
2. Hit up [localhost:8080](http://localhost:8080)


Notes
-----

- tomcat logs are available in the `logs/` subdirectory of this repo.
- tomcat manager app is enabled: [http://localhost:8080/manager](/manager/html) user `tomcat` password `tomcat`.


Heads up
--------

- The database is reset each time the container is run. It can be persisted, open a ticket :)
- postgres, monetdb, and tomcat are all running together in one container, with no attempt to constrain any of their resource usage. YMMV depending on how much RAM is available on your system.
- hot-reloading the java stuff is not there yet.
