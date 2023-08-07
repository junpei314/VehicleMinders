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

  def index
    @vehicles = Vehicle.where(user_id: params[:user_id]).page(params[:page]).per(10)
  end

  def show
    @vehicle = Vehicle.find(params[:vehicle_id])
  end
  
  def new
    @vehicle = Vehicle.new
  end

  def upload
    uploaded_file = params[:csv]
    file_content = uploaded_file.read
    csv_data = CSV.parse(file_content, headers: true)
    csv_data.each do |row|
      vehicle_params = get_vehicle_params(row)
      vehicle = Vehicle.create(vehicle_params)
      create_notification(row, vehicle.id) if row[6].present?
    end
    redirect_to "/vehicles/index/#{current_user.id}"
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
