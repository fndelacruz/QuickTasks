require_relative '../lib/application_base.rb'

router = Router.new

router.draw do
  # root redirects to TasksController :index
  get Regexp.new("^/$"), TasksController, :index

  get Regexp.new("^/public/(?<filepath>\\S+)\/?$"), StaticAssetsController, :show

  get Regexp.new("^/session/new\/?$"), SessionsController, :new
  post Regexp.new("^/session\/?$"), SessionsController, :create
  delete Regexp.new("^/session\/?$"), SessionsController, :destroy

  get Regexp.new("^/users/new\/?$"), UsersController, :new
  post Regexp.new("^/users\/?$"), UsersController, :create

  get Regexp.new("^/tasks/(?<id>\\d+)\/?$"), TasksController, :show
  patch Regexp.new("^/tasks/(?<id>\\d+)\/?$"), TasksController, :update
  put Regexp.new("^/tasks/(?<id>\\d+)\/?$"), TasksController, :update
  delete Regexp.new("^/tasks/(?<id>\\d+)\/?$"), TasksController, :destroy
  delete Regexp.new("^/tasks/(?<filter>complete)\/?$"), TasksController, :destroy
  get Regexp.new("^/tasks\/?$"), TasksController, :index
  get Regexp.new("^/tasks/new\/?$"), TasksController, :new
  post Regexp.new("^/tasks\/?$"), TasksController, :create
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000,
  Host: '0.0.0.0'
)
