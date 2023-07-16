class VehiclesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def home

  end

  def index
    @vehicles = Vehicle.where(user_id: params[:user_id])
  end

  def new
    @vehicle = Vehicle.new
  end

  def upload
    require 'csv'
    uploaded_file = params[:csv]
    # CSVファイルを一時的に保存
    session[:csv_file] = uploaded_file.read
    file_content = uploaded_file.open.read
    # ヘッダーを読み込む
    @headers = CSV.parse_line(file_content.each_line.first)
    session[:headers] = CSV.parse_line(file_content.each_line.first)
    # ヘッダーを表示するビューをレンダリング
    redirect_to "/vehicles/select_columns/#{current_user.id}"
  end

  def select_columns
    @headers = session[:headers]
  end

  # vehicles_controller.rb
  def import
    csv_data = CSV.parse(session.delete(:csv_file), headers: true)
    csv_data.each do |row|
      Vehicle.create(
        maker: row[params[:maker]],
        model: row[params[:model]],
        license_plate: row[params[:license_plate]],
        production_year: row[params[:production_year]],
        lease_expiry: row[params[:lease_expiry]],
        inspection_due: row[params[:inspection_due]],
        user_id: current_user.id
      )
      Notification.create(
        datetime: row[params[:datetime]],
        user_id: current_user.id,
        vehicle_id: Vehicle.last.id
      )
    end
    redirect_to "/vehicles/index/#{current_user.id}"
  end


  def create
    require 'csv'
    uploaded_file = params[:vehicle][:csv]
    CSV.foreach(uploaded_file.path, headers: true) do |row|
      Vehicle.create(maker: row['メーカー'], model: row['モデル'], production_year: row['製造年'], license_plate: row['ナンバープレート'], lease_expiry: row['リース満了日'], inspection_due: row['車検更新日'])
    end
    redirect_to "/vehicles/index/#{current_user.id}"
  end
  
  def show
    @vehicle = Vehicle.find(params[:id])
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
    puts @vehicle.id
  end

  def update
    vehicle = Vehicle.find(params[:id])
    if vehicle.update(vehicles_params)
      # 更新が成功した場合の処理
      redirect_to "/vehicles/index/#{current_user.id}"
    else
      # 更新が失敗した場合の処理
      redirect_to "/vehicles/index/#{current_user.id}"
    end
  end

  def destroy
    vehicle = Vehicle.find(params[:id])
    vehicle.destroy
    redirect_to "/vehicles/index/#{current_user.id}", status: :see_other
  end

  def vehicles_params
    params.require(:vehicle).permit(:maker, :model, :production_year, :license_plate, :lease_expiry, :inspection_due)
  end
end
