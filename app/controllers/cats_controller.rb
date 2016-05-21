class CatsController < ApplicationController
  def index
    if current_user
      @cats = Cat.all
      render :index
    else
      redirect_to '/session/new'
    end
  end

  def show
    @cat = Cat.find(params["id"])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.insert
    redirect_to '/cats'
  end

  def cat_params
    params.require(:cat).permit(:name)
  end
end
