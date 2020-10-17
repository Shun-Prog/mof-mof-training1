class Admin::TasksController < Admin::AdminController
  def index
    @search =
      User.find(params[:user_id]).tasks.preload(:labels).ransack(params[:q])
    @tasks = @search.result.recent.page(params[:page])
  end
end
