# frozen_string_literal: true

# Vehicleモデルの定義
class Vehicle < ApplicationRecord
  # 複数の通知を持つ場合
  has_many :notifications, dependent: :destroy
end
