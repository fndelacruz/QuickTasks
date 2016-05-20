require 'rack'
require 'pry'
require_relative '../lib/router'
require_relative '../lib/cats_controller'
require_relative '../lib/cat.rb'
require_relative '../lib/user.rb'

router = Router.new
router.draw do
  get Regexp.new("^/cats/(?<id>\\d+)\/?$"), CatsController, :show
  get Regexp.new("^/cats\/?$"), CatsController, :index
  get Regexp.new("^/cats/new\/?$"), CatsController, :new
  post Regexp.new("^/cats\/?$"), CatsController, :create
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
