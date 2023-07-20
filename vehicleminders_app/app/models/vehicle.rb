# frozen_string_literal: true

# Vehicleモデルの定義
class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy
end
