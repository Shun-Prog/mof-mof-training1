class ApplicationController < ActionController::Base
  
  # セッション管理用ヘルパーを読み込む
  include SessionsHelper

  def auth_session
      # ログインしていない場合はログインページに飛ばす
      redirect_to login_url unless logged_in?
  end

end
