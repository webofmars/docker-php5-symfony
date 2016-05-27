#!/bin/bash

cd /var/www

if [ -z "$1" ];
    then

    # if you're in china and that for some reason
    # the docker build has failed to download composer.phar...
    if ! which composer; then
        if [ -f composer.phar ]; then
            cp composer.phar /usr/local/bin/composer
            chmod +x /usr/local/bin/composer
        else
            curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
        fi
    fi

  if [ ! -z "$GITHUB_TOKEN" ]; then
      mkdir ~/.composer
      cat > ~/.composer/config.json <<EOS
  {
      "config": {
          "github-oauth": { "github.com": "$GITHUB_TOKEN" }
      }
  }
EOS
  fi
    # we make sure to start fresh
    rm app/config/parameters.yml
    composer install --no-interaction
    if [ -d app/cache ]; then
        rm -rf app/cache/*
    else
        mkdir app/cache
    fi

    # fix permissions
    chmod -R 777 app/logs
    chmod -R 777 app/cache
    touch app/ready
    chmod 666 app/ready

    php app/console assets:install --env=prod --symlink web/
    php app/console c:c
    php app/console c:w

    # Finaly start the composer server
    exec php app/console server:run 0.0.0.0:8000

else
    exec "$@"
fi
