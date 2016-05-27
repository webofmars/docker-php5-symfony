php5-symfony docker image
===========================
- maintener: webofmars <contact@webofmars.com>
- version: 0.1.1

Docker image with everything needed to run symfony commands

/!\ it's only to prepare the project / update composer / run symfony commands
at the end of the setup it will launch the php5 bundled server to test/QA your application
for production use, you need then to look at others images like apache-symfony

- NB: You project should be placed in /var/www/ (no sub-folder)