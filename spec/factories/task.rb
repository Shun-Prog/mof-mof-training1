FactoryBot.define do
  factory :task do
    name { 'タスク名' }
    description { 'タスク詳細' }
    expired_at { Date.today }
  end
end
