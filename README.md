# Simple Java HttpServlet CRUD application

**Simple Java HttpServlet CRUD application** is a persistent Java based CRUD application using a HttpServlet to create and edit products. JSTL is still used for deletion. This project is written in [Java](https://www.oracle.com/java/) using a [PostgreSQL](https://www.postgresql.org/) database.

This strictly educational, proof of concept side project can be found in the Learning Java Web Development course at [O'Reilly](http://shop.oreilly.com/product/0636920048831.do), under "Web Apps And Databases Using JSP And POJOs". A "greedy" pagination solution was also independently implemented, for proof of concept only.

Make note of the use of HttpSessions in this HttpServlet example (DataVerifier.java).

Be sure to check the other branches in this repo to view alernate solutions using JSTL, HttpServlet(s) and dealing with 2 database tables (explicit commits).

## Table of contents

* [Quick start](#quick-start)
* [What's included](#whats-included)
* [Contributors](#contributors)


## Quick start

Here's what you need to do to view this project:

1. Install [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html), the [Apache Tomcat](http://tomcat.apache.org/download-70.cgi) web server and the [Apache Ant](http://ant.apache.org/bindownload.cgi) build tool.
2. Install [PostgreSQL](https://www.postgresql.org/download/). Import the enclosed database (the .backup or .sql file in the `data` folder) into a database called "skistuff". My database has a username of "rupert" and a password of "secret". If you change this, you will have to update the jsp files referencing the database.
3. Set up and start your Apache Tomcat server instance.
4. Within Windows Command Prompt, navigate to the root directory and run the command `ant deploy -Dwar.name=skicrud`.
5. Open your browser and navigate to `http://localhost:8080/skicrud`. Your port number may be different depending on your server instance set up.


### What's included

Within the downloaded files, this is the relevant structure:

```
java-crud-ski-app/
├── build.xml
└── src
    └── data/
        ├── skiStuff.backup
        └── skiStuff.sql
    └── dataV/
        └──DataVerifier.java
    ├── BasicJDBC.java (Can use to create database, but not necessary)
    ├── com.springsource.javax.servlet-2.5.0.jar (Not necessary if using Apache Tomcat)
    ├── jstl-api-1.2.jar
    ├── jstl-imp-1.2.jar
    ├── postgresql-jdbc.jar
    ├── web.xml
    └── *.jsp/html/css
```

## Contributors

**Rupert Ong**

* <https://twitter.com/rupertong>
* <https://github.com/rupert-ong>