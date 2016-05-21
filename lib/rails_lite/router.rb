require_relative 'route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller, action_name|
      add_route pattern, http_method, controller, action_name
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.detect { |route| route.matches?(req) }
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    matching_route = match(req)
    if matching_route
      matching_route.run(req, res)
    else
      res.status = 404
      res.write "404 route not found"
    end
  end
end
