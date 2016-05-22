class TasksController < ApplicationController
  def index
    if current_user
      @tasks = Task.where(owner_id: current_user.id)
      @tasks_done = @tasks.count{ |task| task.complete == 1 }
      @tasks_left = @tasks.length - @tasks_done
      if !@tasks.empty?
        @tasks_pct = ((@tasks_done / @tasks.length.to_f) * 100).to_i
      else
        @tasks_pct = 0
      end
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

  def destroy
    task = Task.find(params[:id])
    task.delete if task.owner_id == current_user.id
    redirect_to '/tasks'
  end

  def task_params
    params.require(:task).permit(:content, :complete)
  end
end
