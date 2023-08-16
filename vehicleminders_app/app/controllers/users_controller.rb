# frozen_string_literal: true

require 'csv'

# UsersController
#
# usersテーブルに対するCRUD処理を行う
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[show edit update destroy]

  def home
    logged_in? ? redirect_to(menu_path(current_user)) : render('home')
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = 'ユーザー登録が完了しました。'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:user_id])
  end

  def update
    @user = User.find(params[:user_id])
    if @user.update(user_params)
      flash[:success] = 'プロフィールを更新しました。'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def download_csv
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :webhook_url, :password, :password_confirmation, :email_notification, :webhook_notification)
  end

  def generate_csv
    CSV.generate do |csv|
      csv << ["メーカー", "モデル", "製造年", "ナンバープレート", "リース満了日", "車検更新日", "通知日"]
      csv << ["Toyota",	"Corolla",	"2005",	"13 さ 1000",	"2023-09-10",	"",	"2022-08-10T12:00:00"]
    end
  end
end
