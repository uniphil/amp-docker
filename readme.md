AMP on Docker
=============

Run a local development copy of AMP in a Docker container with minimal fuss.


Prerequisites
-------------

- [ ] Linux (not yet tested on Mac or Windows -- might work?)
- [ ] Docker
- [ ] A copy of AMP 2.10 or 2.11 source code
- [ ] A database dump from an AMP install


Setup
-----

1. Clone this repository somewhere on your system
2. Run [`./build.sh`](build.sh). Get coffee. Maybe lunch. This takes a while.


Run
---

1. Copy your database dump into this repo as `dump.pgsql`
2. Run ['./run.sh /path/to/amp/checkout'](run.sh)
3. Hit up [http://localhost:8080](localhost:8080)


Heads up
--------

- The database is reset each time the container is run. It can be persisted without too much effort, just has not yet been implemented.
- postgres, monetdb, and tomcat are all running together in one container, with no attempt to constrain any of their resource usage. YMMV depending on how much RAM is available on your system.
- hot-reloading the java stuff is not there yet.


Notes
-----

- tomcat logs are available in the `logs/` subdirectory of this repo.
- tomcat manager app is enabled: [http://localhost:8080/manager](/manager/html) user `tomcat` password `tomcat`.
