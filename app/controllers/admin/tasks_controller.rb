class Admin::TasksController < Admin::AdminController
  def index
    @search =
      User.find(params[:user_id]).tasks.eager_load(:labels).ransack(params[:q])
    @tasks = @search.result.recent.page(params[:page])
  end
end
