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
    @vehicles = Vehicle.where(user_id: params[:user_id])
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
    session[:csv_file] = file_content
    session[:headers] = CSV.parse_line(file_content.each_line.first)
    redirect_to "/vehicles/select_columns/#{current_user.id}"
  end

  def select_columns
    @headers = session[:headers]
  end

  def import
    csv_data = CSV.parse(session.delete(:csv_file), headers: true)
    csv_data.each do |row|
      vehicle_params = get_vehicle_params(row)
      vehicle = Vehicle.create(vehicle_params)
      create_notification(row, vehicle.id) if row[params[:datetime]].present?
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
      maker: row[params[:maker]],
      model: row[params[:model]],
      license_plate: row[params[:license_plate]],
      production_year: row[params[:production_year]],
      lease_expiry: row[params[:lease_expiry]],
      inspection_due: row[params[:inspection_due]],
      user_id: current_user.id
    }
  end

  def create_notification(row, vehicle_id)
    Notification.create(
      datetime: row[params[:datetime]],
      user_id: current_user.id,
      vehicle_id: vehicle_id
    )
  end
end
