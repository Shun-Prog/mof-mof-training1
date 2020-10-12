module TasksHelper

  def current_user_task?(task)
    task.user_id == current_user.id if logged_in?
  end
  
end
