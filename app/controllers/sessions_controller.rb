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
      flash[:first_load] = true
      redirect_to '/tasks'
    else
      @user = User.new(user_params)
      flash.now[:auth_notices] ||= []
      flash.now[:auth_notices] << 'User not found with those credentials.'
      render :new
    end
  end

  def destroy
    logout!
    flash[:auth_notices] ||= []
    flash[:auth_notices] << 'See you next time!'
    redirect_to '/session/new'
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
