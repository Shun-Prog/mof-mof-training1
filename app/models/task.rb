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
    validate :expired_at_valid?
    
    # 一時的にコメントアウト
    # validates :priority
    # validates :status, presence: true

    def expired_at_valid?        
        errors.add(:expired_at, 'は現在日以降の日付を入力してください') if expired_at.nil? || Date.parse(expired_at.to_s) < Date.today
    end

    scope :sorted_by_expired_at, -> (order) {
        case order
        when 'asc' then order(expired_at: :asc)
        when 'desc' then order(expired_at: :desc)
        end
    }

    scope :recent, -> { order(created_at: :desc) }
end
