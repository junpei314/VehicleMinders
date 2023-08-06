# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from Exception, with: :render_500
  end 

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = 'ログインしてください。'
    redirect_to login_url, status: :see_other
  end

  # 正しいユーザーかどうか確認
  def correct_user
    user = User.find(params[:user_id])
    redirect_to("/users/#{current_user.id}", status: :see_other) unless current_user?(user)
  end

  # ログインしているユーザーの車両情報かどうか確認
  def correct_vehicle
    vehicle = Vehicle.find(params[:vehicle_id])
    user = vehicle.user
    redirect_to("/users/#{current_user.id}", status: :see_other) unless current_user?(user)
  end

  # ログインしているユーザーの通知情報かどうか確認
  def correct_notification
    notification = Notification.find(params[:notification_id])
    user = notification.user
    redirect_to("/users/#{current_user.id}", status: :see_other) unless current_user?(user)
  end

  private

  def render_404
    render file: Rails.root.join('public/404.html').to_s, status: :not_found, layout: false, content_type: 'text/html'
  end

  def render_500
    render file: Rails.root.join('public/500.html').to_s, status: :internal_server_error, layout: false, content_type: 'text/html'
  end

end
