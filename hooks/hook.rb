host    = "0.0.0.0"
port    = 6379

redis   = Redis.new(host, port)

upstream_addr = "localhost"
upstream_port = "9000"

secret_key = 'this is the very secret key!'

begin
  hin = Apache::Headers_in.new
  jwt = hin["Cookie"].split("; ").select{|s| s=~/p_tkn=/}.first.split("=").last
  d   = JWT.decode(jwt, secret_key).first
  stored = JWT.decode(redis.get('token:' + d['uid']), secret_key).first['token']

  if d['token'] != stored
    raise Exception.new("Token verification failed, uid: #{d['uid']},token: #{d['token']}")
  else
    r = Apache::Request.new
    r.reverse_proxy "http://#{upstream_addr}:#{upstream_port}" + r.unparsed_uri
    Apache::return(Apache::OK)
  end
rescue Exception => e
  Apache.errlogger Apache::APLOG_NOTICE, "something error occured while checking authorization reason: #{e}"
  Apache::return(Apache::HTTP_PROXY_AUTHENTICATION_REQUIRED)
end

