SECRET_KEY  = 'this is the very secret key!'
REDIS = Redis.new(host: '127.0.0.1', port: '6379')

class Hello < Sinatra::Base
  
  set :public => "public", :static => true

  get "/" do
    @version     = RUBY_VERSION
    @environment = ENV['RACK_ENV']

    erb :welcome
  end

  get "/auth"  do
    uid   = SecureRandom.hex
    token = SecureRandom.hex(64)

    jwt = JWT.encode({"exp"=> (Time.now + 3.days).to_i,
                      "token" => token,
                      "uid"   => uid},
                      SECRET_KEY)

    REDIS.set("token:#{uid}", jwt)
    response.set_cookie('p_tkn', 
                        {:value => jwt,
                         :path => '/',
                         :expires => (Time.now + 3.days)})

    "JWT is published and copied to your Cookie. <br />Your id: #{uid}<br />Your token: #{jwt}"
  end

end
