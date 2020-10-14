class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :show, :update, :destroy]
  before_action :auth_session

  def index
    @search = current_user.tasks.eager_load(:labels).ransack(params[:q])
    @tasks = @search.result(distinct: true).recent.page(params[:page])
  end
  
  def show
  end

  def edit
  end

  def update
      if @task.update(task_params)
        flash[:success] = "タスクを更新しました"
        redirect_to @task
      else
        flash.now[:danger] = "タスクを更新できませんでした"
        render 'edit'
      end
  end
  
  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = "タスクを作成しました"
      redirect_to @task
    else
      flash.now[:danger] = "タスクを作成できませんでした"
      render 'new'
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = 'タスクを削除しました'
      redirect_to tasks_url
    else
      flash.now[:danger] = 'タスクを削除できませんでした'
      render 'edit'
    end
  end
  
  private
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :status, :priority, :expired_at, { label_ids: [] })
    end

end
