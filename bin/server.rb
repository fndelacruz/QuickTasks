require_relative '../lib/application_base.rb'

router = Router.new

router.draw do
  get Regexp.new("^/$"), CatsController, :index
  get Regexp.new("^/session/new\/?$"), SessionsController, :new
  post Regexp.new("^/session\/?$"), SessionsController, :create
  get Regexp.new("^/users/new\/?$"), UsersController, :new
  post Regexp.new("^/users\/?$"), UsersController, :create
  delete Regexp.new("^/session\/?$"), SessionsController, :destroy
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
