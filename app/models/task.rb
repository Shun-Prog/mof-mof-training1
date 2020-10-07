# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text
#  expired_at  :datetime
#  name        :string
#  priority    :integer
#  status      :integer          default("ready")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_status_and_name  (status,name)
#
class Task < ApplicationRecord
    validates :name, presence: true, length: { maximum: 30 }
    validates :description, presence: true, length: { maximum: 1000 }
    validate :expired_at_valid?
    
    # 一時的にコメントアウト
    # validates :priority

    enum status: { 'ready': 0, 'started': 1, 'done': 2 }

    def expired_at_valid?        
        errors.add(:expired_at, 'は現在日以降の日付を入力してください') if expired_at.nil? || Date.parse(expired_at.to_s) < Date.today
    end

    scope :recent, -> { order(created_at: :desc) }
    
end
