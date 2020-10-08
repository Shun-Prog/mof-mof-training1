class ChangeStatusOfTasks < ActiveRecord::Migration[6.0]
  def change
    change_column_default :tasks, :status, from: nil, to: 0
  end
end
