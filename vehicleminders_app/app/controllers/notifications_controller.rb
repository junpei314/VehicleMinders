# frozen_string_literal: true

# NotificationController
#
# このコントローラは、notificationsテーブルへのCRUDを管理します。
#
class NotificationsController < ApplicationController
  before_action :logged_in_user, only: %i[index new create edit update destroy]
  before_action :correct_vehicle, only: %i[index]
  before_action :correct_notification, only: %i[edit update destroy]
  # before_action :combined_datetime, only: %i[create update]

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
    if notification.datetime.present? && notification.save
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    else
      flash[:danger] = '日付と時間を入力してください。'
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    end
  end

  def edit
    @notification = Notification.find(params[:notification_id])
  end

  def update
    notification = Notification.find(params[:notification_id])
    notification.datetime = combined_datetime
    if notification.datetime.present? && notification.save
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    else
      flash[:danger] = '日付と時間を入力してください。'
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    end
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
end
