require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative 'session'
require_relative 'strong_params'
require_relative 'flash'

class ControllerBase
  include StrongParams

  attr_reader :req, :res, :params, :action, :session, :flash

  # Setup the controller
  def initialize(req, res, route_params={})
    @req = req
    @res = res
    @already_built_response = false
    @session = Session.new(req)
    @flash = Flash.new(req)
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
    finalize_response(:redirect)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type, cached=false)
    raise "Already built response!" if already_built_response?
    @res['Content-Type'] = content_type
    if cached
      @res['Cache-Control'] = "public; max-age=31536000"
      @res['Expires'] = (Time.now + 1.year).httpdate
    end
    @res.write(content)
    finalize_response(:render)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.gsub(/Controller$/, '').underscore
    base_template = ERB.new File.read("app/views/layouts/application.html.erb")
    page_template = ERB.new File.read("app/views/#{controller_name}/#{template_name}.html.erb")
    page = page_template.result(call_binding)
    content = base_template.result(call_binding { page })
    render_content(content, "text/html")
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    # used for self-reflection in views
    @action = name

    send(name)
  end

  private

  def finalize_response(response_type)
    flash.store_flash @res
    # elsif response_type == :render
    #   flash.clear_flash @res
    @already_built_response = true
    session.store_session @res
  end

  def call_binding
    binding
  end

  def throw_403
    res.status = 403
    res.write "403 unauthorized access"
  end

  def throw_404(message='404 resource not found')
    res.status = 404
    res.write(message)
  end
end
