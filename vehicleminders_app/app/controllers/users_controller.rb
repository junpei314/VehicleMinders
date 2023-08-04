# frozen_string_literal: true

# UsersController
#
# usersテーブルに対するCRUD処理を行う
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show index edit update destroy]
  before_action :correct_user, only: %i[show index edit update destroy]

  def home
    logged_in? ? redirect_to(user_path(current_user)) : render('home')
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :webhook_url, :password, :password_confirmation, :email_notification, :webhook_notification)
  end
end
