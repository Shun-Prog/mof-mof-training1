# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text
#  expired_at  :datetime
#  name        :string
#  priority    :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
    validates :name, presence: true, length: { maximum: 30 }
    validates :description, presence: true, length: { maximum: 1000 }
    # 一時的にコメントアウト
    # validates :priority
    # validates :status, presence: true
end
