require_relative 'controller_base'

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params["id"])
    render :show
  end
end
