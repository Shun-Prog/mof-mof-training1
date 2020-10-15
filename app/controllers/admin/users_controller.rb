class Admin::UsersController < ApplicationController
  before_action :auth_session
  before_action :require_admin
  before_action :set_user, only: [:edit, :show, :update, :destroy]
  
  def index
    @users = User.all
  end
  
  def show
  end

  def edit
  end

  def update
      if @user.update(user_params)
        flash[:success] = "ユーザーを更新しました"
        redirect_to admin_user_url(@user)
        
      else
        flash.now[:danger] = "ユーザーを更新できませんでした"
        render 'edit'
      end
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザーを作成しました"
      redirect_to admin_user_url(@user)
    else
      flash.now[:danger] = "ユーザーを作成できませんでした"
      render 'new'
    end
  end

  def destroy
    if @user.destroy
      logout if current_user.id == @user.id
      flash[:success] = 'ユーザーを削除しました'
      redirect_to admin_users_url
    else
      flash.now[:danger] = 'ユーザーを削除できませんでした'
      render 'edit'
    end
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
    
end
