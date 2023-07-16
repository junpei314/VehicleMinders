class NotificationsController < ApplicationController

  def index
    @notifications = Notification.where(vehicle_id: params[:vehicle_id])
    @notification = Notification.new
    @vehicle_id = params[:vehicle_id]
    @user_id = current_user.id
  end

  def create
    combined_datetime
    @notification = Notification.new(notification_params)
    @notification.datetime = @datetime
    if @datetime.present? && @notification.save
      redirect_to "/notifications/index/#{notification_params[:vehicle_id]}"
    else
      redirect_to "/notifications/index/#{notification_params[:vehicle_id]}", status: :unprocessable_entity
    end
  end

  def edit
    @notification = Notification.find(params[:id])
    @date = @notification.datetime.to_date # Dateオブジェクトに変換
    @time = @notification.datetime.strftime("%H:%M") # "HH:MM" 形式の文字列に変換
  end

  def update
    combined_datetime
    notification = Notification.find(params[:id])
    if notification.update(datetime: @datetime)
      # 更新が成功した場合の処理
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    else
      # 更新が失敗した場合の処理
      redirect_to "/notifications/index/#{notification.vehicle_id}"
    end
  end

  def destroy
    notification = Notification.find(params[:id])
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
    
    # Combine the date and time into a single datetime
    @datetime = DateTime.strptime("#{date_str}#{time_str}", "%Y-%m-%d %H:%M") if date_str.present? && time_str.present?
    # Remove the date and time keys from the params
    params[:notification].delete(:date)
    params[:notification].delete(:time)
    @datetime
  end
end
