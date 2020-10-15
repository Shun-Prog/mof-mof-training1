class ApplicationController < ActionController::Base
  # セッション管理用ヘルパーを読み込む
  include SessionsHelper

  def auth_session
      # ログインしていない場合はログインページに飛ばす
      redirect_to login_url unless logged_in?
  end

  def require_admin
    # 管理者権限が無い場合は例外を投げる
    raise StandardError, "管理者権限がありません" if controller_path.start_with?("admin") && !current_user.admin?
  end

end
