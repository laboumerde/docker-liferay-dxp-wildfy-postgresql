## Docker image for Liferay v7.x bundeled with wildfly and PostgreSQL 10

The project will build a docker image with up and running Liferay 7.x distribution. The image include :

* PostgreSQL 10 database

* JDK installation from provided tar.gz  

* Liferay installation from provided Liferay-portal-wildfly-x bundle zip archive

**Note :** The docker image should not be used in production environment.

This image is based on Ikizema (https://github.com/ikizema) liferay docker image : https://github.com/ikizema/docker-postgre9.3-liferay

## Required Customization

Before running the docker builder, you need to provide following packages in ./assets/packages/ folder :

* Oracle JDK archive : jdk-8uXX-linux-x64.tar.gz

* Official Liferay Portal wildfly bundle .zip archive : liferay-portal-wildfly-7.x<...>.zip

Added to those packages, you may need to create a "/opt/liferay/docker" folder to be able to link a host deploy folder to the one in the container (used in the docker run command below)

## Build & Run & Start

From project root folder :

    docker build -t liferay-7-x-x .
    JOB=$(docker run -d -v /opt/liferay/docker:/opt/liferay/deploy -p 50022:22 -p 55432:5432 -p 58080:8080 -p 58787:8787 --name liferay-7-x-x liferay-7-x-x)
    docker start $JOB

Note :

    Arbitrary image and container name : liferay-7-x-x
    Arbitrary port mapping :
        port 22 is mapped to 50022 (ssh)
        port 5432 is mapped to 55432 (postgresql)
        port 8080 is mapped to 58080 (wildfly)
        port 8787 is mapped to 58787 (wildfly debug port)

## Accounts :

System account :

    user : root
    pwd : admin

Database accounts :

    PostgreSQL administration :
        user : docker
        pwd : docker

    Liferay Database : lportal
        user : lportal
        pwd : lportal

## Access to Liferay Portal :

Open **http://localhost:58080** in the browser of your choice and finish portal initialization.

**Note :** Please note that the first Liferay startup can take up to few minutes.

## Obvious Tips

* Change the image and instance names

* You can connect via ssh :

    ssh root@localhost -p 50022

* To restart the wildfly server (by killing the process, the supervisor will restart it... Yeah... might be enhanced)

    ps aux | grep wildfly
    kill -9 xx

* Db remote connexion and remote debugging available (55432, 58787)

* if you are using maven for your liferay development and following above instruction on shared folders

    <profile>
        <id>liferay-docker</id>
        <properties>
            <liferay.auto.deploy.dir>/opt/liferay/docker/deploy</liferay.auto.deploy.dir>
        </properties>
    </profile>
