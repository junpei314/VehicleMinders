# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
    # beforeフィルタ

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'ログインしてください。'
    redirect_to login_url, status: :see_other
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:user_id])
    redirect_to("/users/#{current_user.id}", status: :see_other) unless current_user?(@user)
  end

  # 正しいユーザーかどうか確認
  def correct_vehicle
    @vehicle = Vehicle.find(params[:vehicle_id])
    @user = User.find(@vehicle.user_id)
    redirect_to("/users/#{current_user.id}", status: :see_other) unless current_user?(@user)
  end

  # 正しいユーザーかどうか確認
  def correct_notification
    @notification = Notification.find(params[:notification_id])
    @user = User.find(@notification.user_id)
    redirect_to("/users/#{current_user.id}", status: :see_other) unless current_user?(@user)
  end

  # ↑データが存在しないときにエラー画面になるのを修正するために追加
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
end
