class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :show, :update]

  def index
    @tasks = Task.all
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
        flash[:error] = "タスクを更新できませんでした"
        render 'edit'
      end
  end
  
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "タスクを作成しました"
      redirect_to @task
    else
      flash[:error] = "タスクを作成できませんでした"
      render 'new'
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description)
    end

end
