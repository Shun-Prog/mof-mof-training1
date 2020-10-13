if Rails.env.development?

  # 一般ユーザー作成
  user = User.create!(
    name: "ダミーユーザー",
    email: "dummy@example.com",
    password: "12345678"
  )

  # 一般ユーザータスク作成
  100.times do |n|
    Task.create!(
      name: "タスク名#{n + 1}",
      description: "タスク詳細#{n + 1}", 
      expired_at: Date.today,
      user_id: user.id
    )
  end

  # 管理者ユーザー作成
  User.create!(
    name: "管理者",
    email: "admin@example.com",
    password: "12345678"
    admin: true
  )

end
