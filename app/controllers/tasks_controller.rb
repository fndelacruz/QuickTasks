class TasksController < ApplicationController
  def index
    if current_user
      @tasks = Task.where(owner_id: current_user.id)
      render :index
    else
      redirect_to '/session/new'
    end
  end

  def show
    @task = Task.find(params["id"])
    render :show
  end

  def new
    @task = Task.new
    render :new
  end

  def create
    @task = Task.new(task_params)
    @task.owner_id = current_user.id
    @task.save
    redirect_to '/tasks'
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params) if task.owner_id == current_user.id
    redirect_to '/tasks'
  end

  def task_params
    params.require(:task).permit(:content, :complete)
  end
end
