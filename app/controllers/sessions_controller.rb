class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user&.authenticate(session_params[:password])
      login(user)
      flash[:success] = 'ログインしました'
      redirect_to tasks_path
    else
      flash.now[:danger] = 'ログインできませんでした'
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    flash[:success] = 'ログアウトしました'
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
