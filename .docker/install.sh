#!/bin/bash

if [ ! -e "./flags/installed" ]; then
    echo -e "\e[33mCloning project repository and checking out to 'demo' branch...\e[0m"
    git clone https://github.com/RedSign77/m24-sandbox ../magento

    echo -e "\e[33mCreating traefik docker network...\e[0m"
    docker network create traefik || true

    echo -e "\e[33mBuilding and starting services...\e[0m"
    docker-compose build
    docker-compose up -d --force-recreate

    echo -e "\e[33mCopying auth.json to Magento root...\e[0m"
    cp ../data/auth.json ../magento/

    echo -e "\e[33mInstalling composer packages...\e[0m"
    docker exec --user=www-data $(docker-compose ps -q php-fpm) composer install

    echo -e "\e[33mInstalling Magento...\e[0m"
    while ! docker exec -i $(docker-compose ps -q mariadb) mysqladmin -uroot -proot --host '127.0.0.1' ping --silent &> /dev/null ; do
        echo -e "\e[33mWaiting for database connection...\e[0m"
        sleep 1
    done
    docker exec --user=www-data $(docker-compose ps -q php-fpm) php bin/magento setup:install \
        --base-url=http://sandboxm2.localhost/ \
        --base-url-secure=https://sandboxm2.localhost/ \
        --db-host=mariadb --db-name=magento --db-user=default --db-password=secret \
        --admin-firstname=Admin --admin-lastname=Test --admin-email=sandboxm2@localhost.com \
        --admin-user=admin --admin-password=Admin1234 --language=en_US \
        --currency=EUR --timezone=UTC --use-rewrites=1 --use-secure-admin=1 --backend-frontname=sboxadmin \
        --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch \
        --elasticsearch-port=9200

    echo -e "\e[33mConfigure Redis as default and page cache...\e[0m"
    docker exec --user=www-data $(docker-compose ps -q php-fpm) php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=0
    docker exec --user=www-data $(docker-compose ps -q php-fpm) php bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1

    echo -e "\e[33mDisabling unnecessary modules...\e[0m"
    docker exec --user=www-data $(docker-compose ps -q php-fpm) php bin/magento module:disable Yotpo_Yotpo Magento_TwoFactorAuth Dotdigitalgroup_Email Dotdigitalgroup_Chat

    echo -e "\e[33mCleaning cache...\e[0m"
    docker exec --user=www-data $(docker-compose ps -q php-fpm) php bin/magento cache:clean

    mkdir ../.docker/flags
    touch ../.docker/flags/installed
    echo -e "\e[32mProject installed successfully(?)!\e[0m"
else
    echo -e "\e[32mThe project is already installed!\e[0m"
fi