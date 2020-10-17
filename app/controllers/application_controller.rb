class ApplicationController < ActionController::Base # セッション管理用ヘルパーを読み込む
  include SessionsHelper

  def auth_session
    redirect_to login_url unless logged_in?
  end # ログインしていない場合はログインページに飛ばす
end
