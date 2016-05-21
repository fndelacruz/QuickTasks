class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    user = User.find_by_credentials(
      user_params[:username],
      user_params[:password]
    )
    if user
      login!(user)
      redirect_to '/tasks'
    else
      @user = User.new(user_params)
      render :new
    end
  end

  def destroy
    logout!
    redirect_to '/session/new'
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
