#!/bin/sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv local 2.1 && ruby -v

/usr/local/bin/redis-server /etc/redis.conf

/etc/init.d/httpd start

cd /data/hello
bundle exec unicorn -c config/unicorn.rb -l 0.0.0.0:8080 &

tail -f /var/log/httpd/access_log &
tail -f /var/log/httpd/error_log &
tail -F /data/hello/log/stderr.log &
tail -F /data/hello/log/stdout.log

