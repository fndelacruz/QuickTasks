require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative 'session'
require_relative 'strong_params'

class ControllerBase
  include StrongParams

  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params={})
    @req = req
    @res = res
    @already_built_response = false
    @session = Session.new(req)
    @params = Params.parameterize(route_params.merge @req.params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Already built response!" if already_built_response?
    @res['Location'] = url
    @res.status = 302
    @already_built_response = true
    session.store_session @res
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already built response!" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
    session.store_session @res
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.gsub(/Controller$/, '').underscore
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    render_content(ERB.new(template).result(binding), "text/html")
  end

  # method exposing a `Session` object
  def session
    @session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    send(name)
  end
end
