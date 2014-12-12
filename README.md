jwt-auth-proxy
==============

Authentication proxy with apache mod_mruby, and using redis backend as JWT store

How to run
----------

- Run container


    git clone https://github.com/prevs-io/jwt-auth-proxy.git
    docker build -t jwt-auth-proxy .
    docker run -t --rm -p 8080:8080 -p 80:80 jwt-auth-proxy

- Access resources through proxy 


    $ curl -vI http://0.0.0.0/
    ...
    HTTP/1.1 407 Proxy Authentication Required
    < Date: Fri, 12 Dec 2014 04:39:14 GMT
    Date: Fri, 12 Dec 2014 04:39:14 GMT
    ...
    * Closing connection 0

- Authentication with auth application


    $ curl -v http://0.0.0.0:8080/auth
    ...
    < HTTP/1.1 200 OK
    < Date: Fri, 12 Dec 2014 04:49:49 GMT
    < Status: 200 OK
    < Connection: close
    < Content-Type: text/html;charset=utf-8
    < Set-Cookie: p_tkn=<token blah blah blah>; path=/; expires=Mon, 15 Dec 2014 04:49:49 -0000

- Access resouce through the proxy again


    $ curl -I --cookie p_tkn='<token blah blah blah>; path=/; expires=Mon, 15 Dec 2014 04:42:37 -0000' http://0.0.0.0/
    HTTP/1.1 200 OK
    Date: Fri, 12 Dec 2014 04:45:49 GMT
    Status: 200 OK
    Content-Type: text/html;charset=utf-8
    Content-Length: 1873
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    Connection: close
　
