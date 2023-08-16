# frozen_string_literal: true

# NotificationController
#
# このコントローラは、notificationsテーブルへのCRUDを管理します。
#
class NotificationsController < ApplicationController
  before_action :logged_in_user, only: %i[index new create edit update destroy]
  before_action :correct_vehicle, only: %i[index]
  before_action :correct_notification, only: %i[edit update destroy]

  def index
    @notifications = Notification.where(vehicle_id: params[:vehicle_id])
    @vehicle_id = params[:vehicle_id]
  end
  
  def new
    @notification = Notification.new
    @vehicle_id = params[:vehicle_id]
    @user_id = current_user.id
  end

  def create
    notification = Notification.new(user_id: notification_params[:user_id], vehicle_id: notification_params[:vehicle_id])
    notification.datetime = combined_datetime
    save_and_redirect(notification)
  end

  def edit
    @notification = Notification.find(params[:notification_id])
  end

  def update
    notification = Notification.find(params[:notification_id])
    notification.datetime = combined_datetime
    save_and_redirect(notification)
  end

  def destroy
    notification = Notification.find(params[:notification_id])
    notification.destroy
    redirect_to "/notifications/index/#{notification.vehicle_id}", status: :see_other
  end

  private

  def notification_params
    params.require(:notification).permit(:date, :time, :user_id, :vehicle_id)
  end

  def combined_datetime
    date_str = notification_params[:date]
    time_str = notification_params[:time]
    DateTime.strptime("#{date_str}#{time_str}", '%Y-%m-%d %H:%M') if date_str.present? && time_str.present?
  end

  def save_and_redirect(notification)
    if notification.save
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    else
      flash[:danger] = notification.errors.full_messages.join(', ')
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    end
  end
end
