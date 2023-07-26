# frozen_string_literal: true

# UsersController
#
# usersテーブルに対するCRUD処理を行う
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show index edit update destroy]
  before_action :correct_user, only: %i[show index edit update destroy]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:user_id])
    # @vehicles = Vehicle.where(user_id: @user.id) vehiclesテーブルにuser_idを追加できたらコメントアウト解除
    @vehicles = Vehicle.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = 'ユーザー登録が完了しました。'
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
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
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # beforeフィルタ

  # # 正しいユーザーかどうか確認
  # def correct_user
  #   @user = User.find(params[:id])
  #   redirect_to("/users/#{current_user.id}", status: :see_other) unless current_user?(@user)
  # end
end
