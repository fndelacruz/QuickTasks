class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    path_match = !!(@pattern =~ req.path)
    method_match = @http_method.to_s == req.request_method.downcase
    path_match && method_match
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    match_data = @pattern.match(req.path)
    route_params = (match_data.names).zip(match_data.captures).to_h
    @controller_class.new(req, res, route_params).invoke_action(@action_name)
  end
end
