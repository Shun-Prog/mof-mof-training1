if Rails.env.development?
  user = User.create!(
    name: "ダミーユーザー",
    email: "dummy@example.com",
    password: "12345678"
  )
  # タスク作成のseed
  Task.delete_all
  100.times do |n|
    Task.create!(
      name: "タスク名#{n + 1}",
      description: "タスク詳細#{n + 1}", 
      expired_at: Date.today,
      user_id: user.id
    )
  end
end
