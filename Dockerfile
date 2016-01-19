FROM tutum/lamp:latest

RUN apt-get update && apt-get install -y wget curl php5-curl php5-sqlite

RUN rm -fr /app && git clone https://github.com/adam2314/linet3.git /app

# Add your github credentials to the composer:
ADD auth.json /root/.composer/auth.json
RUN sed -i"" 's/REPLACE_ME_PLEASE/GITHUB_TOKEN/' /root/.composer/auth.json

RUN cd /app/protected && \
  curl -sS https://getcomposer.org/installer | php && \
  ./composer.phar update
# Yep.. We need to run this twice..!
RUN cd /app/protected && \
  ./composer.phar update

#RUN cd /app/protected && \
#  wget https://github.com/yiisoft/yii/releases/download/1.1.17/yii-1.1.17.467ff50.tar.gz && \
#  tar xzf yii-1.1.17.467ff50.tar.gz && \
#  rm yii-1.1.17.467ff50.tar.gz && \

RUN chown -R www-data /app

RUN sed -i"" 's/AllowOverride FileInfo/AllowOverride All/' /etc/apache2/sites-enabled/000-default.conf

ADD mysql-setup.sh /mysql-setup.sh

EXPOSE 80 3306
CMD ["/run.sh"]
