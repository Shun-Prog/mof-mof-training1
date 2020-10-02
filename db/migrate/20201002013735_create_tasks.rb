class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :status
      t.datetime :expired_at
      t.integer :priority

      t.timestamps
    end
  end
end
