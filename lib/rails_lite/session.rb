require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie_json = req.cookies['_rails_lite_app']
    @cookie = cookie_json ? JSON.parse(cookie_json) : {}
  end

  def [](key)
    @cookie[key.to_s]
  end

  def []=(key, val)
    @cookie[key.to_s] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_rails_lite_app', path: "/", value: @cookie.to_json)
  end
end
