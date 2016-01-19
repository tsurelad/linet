#!/bin/bash

mysql -uroot -e "CREATE DATABASE linet CHARACTER SET utf8 COLLATE utf8_general_ci"
mysql -uroot -e "CREATE USER 'linet'@'localhost' IDENTIFIED BY 'linet'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'linet'@'localhost'"
mysql -uroot -e "FLUSH PRIVILEGES"
