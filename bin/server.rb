require 'rack'
require 'pry'
require_relative '../lib/router'
require_relative '../lib/cats_controller'
require_relative '../lib/cat.rb'

router = Router.new
router.draw do
  get Regexp.new("^/cats/(?<id>\\d+)\/?$"), CatsController, :show
  get Regexp.new("^/cats\/?$"), CatsController, :index
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)