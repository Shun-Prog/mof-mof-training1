class Admin::TasksController < ApplicationController
  def index
    @search = User.find(params[:user_id]).tasks.ransack(params[:q])
    @tasks = @search.result.recent.page(params[:page])
  end
end
