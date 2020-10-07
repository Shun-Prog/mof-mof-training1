if Rails.env.development?
  # タスク作成のseed
  10000.times do |n|
    Task.create!(
      name: "タスク名#{n + 1}",
      description: "タスク詳細#{n + 1}", 
      expired_at: Date.today
    )
  end
end
