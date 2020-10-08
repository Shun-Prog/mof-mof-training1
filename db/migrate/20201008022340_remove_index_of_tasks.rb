class RemoveIndexOfTasks < ActiveRecord::Migration[6.0]
  def change
    remove_index :tasks, column: [:status, :name]
  end
end
