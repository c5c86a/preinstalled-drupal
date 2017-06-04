#!/bin/bash
#
set -e
set -x

log () { 
  tail -n 2 /var/log/apache2/access.log 
  tail -n 50 /var/log/apache2/error.log
  exit 1
}
fail () { 
  echo -e "\n$1\n"
  exit 1
}
failsql () { 
  tail -n 50 /var/log/mysql/error.log
  echo -e "\nExpected mysql to be up\n"
  exit 1
}
supervisorctl status mysqld || failsql
supervisorctl status httpd || fail "Expected apache2 to be up"

echo 'db is drupal, db user is drupal and ui admin ps is admin'
#  cat /drupal-db-pw.txt 
#  cat /mysql-root-pw.txt

cd /var/www/html
#drush status || log
#drush status | egrep 'Drush version.*8.1.10' || fail "expected drush 8.1.10"
#drush status | egrep 'Drupal version.*8.2.3' || fail "expected drupal 8.2.3"
drush pml
drush pml | grep json_field || fail "expected to find module json_field"
drush pml | grep weight || fail "expected to find module weight"

drush en json_field -y
drush en weight -y

mkdir -p /var/www/html/modules/custom/fbchatbot
cp /opt/module/fbchatbot* /var/www/html/modules/custom/fbchatbot/
cp -r /opt/module/src /var/www/html/modules/custom/fbchatbot/
cp -r /opt/module/css /var/www/html/modules/custom/fbchatbot/
cp -r /opt/module/js /var/www/html/modules/custom/fbchatbot/
cp -r /opt/module/templates /var/www/html/modules/custom/fbchatbot/
cp -r /opt/module/config /var/www/html/modules/custom/fbchatbot/
drush en fbchatbot -y

drush pml | egrep 'json_field.*Enabled' || fail "expected to find module json_field enabled"
drush pml | egrep 'weight.*Enabled' || fail "expected to find module weight enabled"
drush pml | egrep 'fbchatbot.*Enabled' || fail "expected to find module fbchatbot enabled"

curl -s --head http://drupal | grep "HTTP/1.1 200 OK" || log
