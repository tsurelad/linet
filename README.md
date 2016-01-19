Linet Docker
============

This project is meant to ease the installation process of
the [linet][linet] accounting program, by
using [docker][docker].

Our Dockerfile is based on the [tutum/lamp][tutumlamp]
docker ([github repo][tutumlamprepo]).

Please read the documentation of the [tutum/lamp][tutumlamp] docker for more 
details. Important stuff are listed below.


TL;DR
-----

```
sed -i"" 's/GITHUB_TOKEN/38a.................858/' Dockerfile                   
docker build -t linet .
mkdir -p ~/linet/mysql/lib
docker run -d -p 8888:80 -p 3306:3306 --name linet -v ~/linet/mysql/lib:/var/lib/mysql linet
```


Building the docker
-------------------

Clone this repository, and inside the cloned folder run this to create a local
*linet* docker image (obviously put your real [GitHub OAuth Token][githubtoken]
instead of the 38a.....858 placeholder):

```
sed -i"" 's/GITHUB_TOKEN/38a.................858/' Dockerfile
docker build -t linet .
```

The [GitHub OAuth Token][githubtoken] is needed for the composer step to fetch
all dependencies from GitHub.


Running the docker container
----------------------------

Running the docker for the first time will create the MySQL database with the
proper DB for [linet][linet], and set up the following:

* *root* user with no password for localhost access only (from within the docker)

* *linet* database

* *linet* user with the password *linet* with all privileges from localhost

* *admin* user with a random password for accessing the DB outside of localhost.
  The admin password is written to the docker logs, and can be found by running
  `docker logs linet`. You can also run the docker with an environment variable
  with the admin password: `-e MYSQL_PASS="mypass"`. See [Tutum/Lamp][tutumlamp]
  for more details.

You can change the initial setup of the DB, including those usernames and
passwords by editing the *mysql-setup.sh* file before you build the docker image.


In order to run the docker you just need to run:

```
docker run -d -p 80:80 --name linet linet
```

This will launch the docker container with the name linet from your image (who
is also named linet). Docker will map your host machine's port 80 to the internal
docker port 80. This enables you to visit your local linet webapp by visiting
http://localhost (Note first that you need to install linet by visiting
http://localhost/install ).

If you want to map a different port for the webapp, or you want to access mysql
from outside of the docker container, e.g. 8888, you can run:

```
docker run -d -p 8888:80 -p 3306:3306 --name linet linet
```

And then the linet webapp will be available in http://localhost:8888 and 3306
is the port for your mysql access.

Last thing is the mysql folder. You *should* map a docker volume to the mysql
lib folder, and make sure to always map the same folder, and to backup it as
seems appropriate. You can do it by running:

```
mkdir -p ~/linet/mysql/lib
```

and then use this folder for your MySQL use:

```
docker run -d -p 8888:80 -p 3306:3306 --name linet -v ~/linet/mysql/lib:/var/lib/mysql linet
```


Stopping and Resuming the docker container
------------------------------------------

You can always stop the docker container by running:

```
docker stop linet
```

and resume it again by running:

```
docker start linet
```

If you want to completely remove the docker image run:

```
docker rm -f linet
```

If you have mapped the external MySQL folder then you should be able to get
linet working with the same data you had by just re-running:

```
docker run -d -p 8888:80 -p 3306:3306 --name linet -v ~/linet/mysql/lib:/var/lib/mysql linet
```


Post Installation
-----------------

Please go to the installation of the local linet (http://localhost:8888/install)
and make sure the screen shows that everything is OK. Click on "Next" and then
change the default MySQL username from _root_ to _linet_. Make sure the DB name
is _linet_ and the password is _linet_ as well.
Click on the "Next" button and finish the technical installation.

The next step is to visit [Linet Post Install][linetpostinstall] page to make
sure you create a proper setup.

Good luck!


[linet]: https://www.linet.org.il  "Linet Homepage"
[docker]: https://www.docker.com/  "Docker Homepage"
[tutumlamp]: https://hub.docker.com/r/tutum/lamp/  "Tutum/Lamp Docker Hub"
[tutumlamprepo]: https://github.com/tutumcloud/lamp  "Tutum/Lamp GitHub Repository"
[githubtoken]: https://github.com/settings/tokens "GitHub OAuth Token"
[linetpostinstall]: https://www.linet.org.il/support/%D7%9E%D7%93%D7%A8%D7%99%D7%9A-%D7%94%D7%AA%D7%A7%D7%A0%D7%94-%D7%9C%D7%9C%D7%99%D7%A0%D7%98-%D7%AA%D7%95%D7%9B%D7%A0%D7%AA-%D7%94%D7%A0%D7%94%D7%9C%D7%AA-%D7%97%D7%A9%D7%91%D7%95%D7%A0%D7%95%D7%AA/%D7%94%D7%AA%D7%A7%D7%A0%D7%AA-%D7%9C%D7%99%D7%A0%D7%98-%D7%A2%D7%9C-%D7%9E%D7%97%D7%A9%D7%91-%D7%9C%D7%99%D7%A0%D7%95%D7%A7%D7%A1?id=15  "Linet Post Install Steps"

