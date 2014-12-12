FROM sonots/docker-ruby

MAINTAINER Naoki AINOYA <ainonic@gmail.com>

WORKDIR /data

RUN bash -lc 'rbenv global 2.1'

RUN yum -y install mysql-devel --enablerepo=remi
RUN yum install -y bison
RUN yum install -y gcc-c++
RUN yum install -y git
RUN yum install -y glibc-headers
RUN yum install -y hiredis-devel
RUN yum install -y httpd
RUN yum install -y httpd-devel
RUN yum install -y libyaml-devel
RUN yum install -y openssl-devel
RUN yum install -y readline
RUN yum install -y readline-devel
RUN yum install -y tar
RUN yum install -y zlib
RUN yum install -y zlib-devel

# Copy the Gemfile and Gemfile.lock into the image. 
# Temporarily set the working directory to where they are. 
WORKDIR /tmp/hello
ADD hello/Gemfile Gemfile
ADD hello/Gemfile.lock Gemfile.lock
RUN bash -lc 'bundle install'
ADD hello /data/hello

# Install mod_mruby
RUN git clone https://github.com/matsumoto-r/mod_mruby.git /tmp/mod_mruby
RUN ln -s ~/.rbenv/shims/ruby /usr/local/bin/ruby
RUN ln -s ~/.rbenv/shims/rake /usr/local/bin/rake
WORKDIR /tmp/mod_mruby

ADD conf/build_config.rb /tmp/mod_mruby/build_config.rb
RUN chmod u+x ./build.sh
RUN bash -lc 'export PATH=/usr/local/bin:$PATH && ./build.sh'
RUN make install

ADD ./conf/httpd.conf /etc/httpd/
ADD ./conf/mruby.conf /etc/httpd/conf.d/

ADD scripts /data/scripts
ADD hooks /data/hooks

WORKDIR /data/hello
RUN mkdir -p tmp/{log,pids}

ENV REDIS_HOST 127.0.0.1
ENV REDIS_PORT 6379

CMD bash -lc /data/scripts/start.sh
