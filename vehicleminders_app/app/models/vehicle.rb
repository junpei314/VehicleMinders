# frozen_string_literal: true

# Vehicleモデルの定義
class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy

  validate :either_inspection_due_or_lease_expiry

  private

  def either_inspection_due_or_lease_expiry
    if inspection_due.present? && lease_expiry.present?
      errors.add(:base, '車検更新日とリース満了日のどちらか一方のみを入力してください')
    elsif inspection_due.blank? && lease_expiry.blank?
      errors.add(:base, '車検更新日またはリース満了日を入力してください')
    end
  end
end
