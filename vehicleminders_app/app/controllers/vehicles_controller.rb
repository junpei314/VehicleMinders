class VehiclesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @vehicles = Vehicle.all
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    require 'csv'
    uploaded_file = params[:vehicle][:csv]
    puts '↓'
    puts uploaded_file.path
    CSV.foreach(uploaded_file.path, headers: true) do |row|
      Vehicle.create(maker: row['メーカー'], model: row['モデル'], production_year: row['製造年'], license_plate: row['ナンバープレート'], lease_expiry: row['リース満了日'], inspection_due: row['車検更新日'])
    end

    redirect_to action: "index"
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
      redirect_to "http://localhost:3000/vehicles"
    else
      # 更新が失敗した場合の処理
      redirect_to "http://localhost:3000/vehicles"
    end
  end

  def destroy
    vehicle = Vehicle.find(params[:id])
    vehicle.destroy
    redirect_to "http://localhost:3000/vehicles", status: :see_other
  end

  def vehicles_params
    params.require(:vehicle).permit(:maker, :model, :production_year, :license_plate, :lease_expiry, :inspection_due)
  end
end
