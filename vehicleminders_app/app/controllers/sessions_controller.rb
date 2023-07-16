# frozen_string_literal: true

# SessionsController
#
# このコントローラは、ユーザーのセッション管理を担当します。具体的には、ユーザーのログインとログアウトの
# 機能を提供します。
#
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in_and_redirect(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def log_in_and_redirect(user)
    forwarding_url = session[:forwarding_url]
    reset_session
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    log_in user
    redirect_to forwarding_url || user
  end
end
