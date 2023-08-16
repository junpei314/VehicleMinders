# frozen_string_literal: true

require 'csv'

# VehiclesController
#
# vehiclesテーブルに対してCRUD処理を行うコントローラー
class VehiclesController < ApplicationController
  before_action :logged_in_user, only: %i[index new create show edit update destroy]
  before_action :correct_user, only: %i[index]
  before_action :correct_vehicle, only: %i[edit update destroy]
  skip_before_action :verify_authenticity_token

  def menu
    @user = User.find(current_user.id)
  end

  def index
    @vehicles = Vehicle.where(user_id: params[:user_id]).page(params[:page]).per(10)
    @user_id = params[:user_id]
  end

  def show
    @vehicle = Vehicle.find(params[:vehicle_id])
  end
  
  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = current_user.vehicles.build(vehicles_params)
    if @vehicle.save
      flash[:success] = 'データ登録が完了しました。'
      redirect_to "/vehicles/index/#{current_user.id}"
    else
      flash[:danger] = 'データ登録に失敗しました。'
      redirect_to "/vehicles/new/#{current_user.id}"
    end
  end

  def select_csv
    @vehicle = Vehicle.new
  end

  def upload
    unless params[:csv].present?
      flash[:danger] = 'CSVファイルを選択してください' 
      return redirect_to select_csv_path(current_user.id)
    end
    import_csv_data(params[:csv].read)
    redirect_to vehicles_for_user_path(current_user.id)
  end

  def edit
    @vehicle = Vehicle.find(params[:vehicle_id])
  end

  def update
    vehicle = Vehicle.find(params[:vehicle_id])
    unless vehicle.update(vehicles_params)
      flash[:danger] = '更新に失敗しました。'
    end
    redirect_to "/vehicles/index/#{current_user.id}"
  end

  def destroy
    vehicle = Vehicle.find(params[:vehicle_id])
    vehicle.destroy
    redirect_to "/vehicles/index/#{current_user.id}", status: :see_other
  end

  private

  def vehicles_params
    params.require(:vehicle).permit(:maker, :model, :production_year, :license_plate, :lease_expiry, :inspection_due)
  end

  def import_csv_data(file_content)
    csv_data = CSV.parse(file_content, headers: true)
    csv_data.each do |row|
      vehicle_params = get_vehicle_params(row)
      vehicle = Vehicle.create(vehicle_params)
      create_notification(row, vehicle.id) if row[6].present?
    end
  end

  def get_vehicle_params(row)
    {
      maker: row[0],
      model: row[1],
      production_year: row[2],
      license_plate: row[3],
      lease_expiry: row[4],
      inspection_due: row[5],
      user_id: current_user.id
    }
  end

  def create_notification(row, vehicle_id)
    Notification.create(
      datetime: row[6],
      user_id: current_user.id,
      vehicle_id: vehicle_id
    )
  end
end
