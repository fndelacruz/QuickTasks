require 'json'

class Flash
  attr_reader :now

  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @now = {}
    cookie_json = req.cookies['_rails_lite_app_flash']
    @cookie = cookie_json ? JSON.parse(cookie_json) : {}
  end

  def [](key)
    @now[key] || @cookie[key.to_s]
  end

  def []=(key, val)
    @cookie[key.to_s] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_flash(res)
    return if @cookie.empty?
    if @cookie['_expiring']
      cookie_json = {}.to_json
    else
      @cookie['_expiring'] = true
      cookie_json = @cookie.to_json
    end
    res.set_cookie('_rails_lite_app_flash', path: "/", value: cookie_json)
  end
end
