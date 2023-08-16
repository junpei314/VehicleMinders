# frozen_string_literal: true

# ReminderWebhookWorker
#
# このワーカーは、メール送信を管理します。
#
require 'net/http'
require 'uri'
require 'json'

class ReminderWebhookWorker
  include Sidekiq::Worker

  def perform(notification_id)
    notification = Notification.find(notification_id)
    vehicle = notification.vehicle
    user = notification.user

    message = build_message(user, vehicle)

    send_to_teams_webhook(user.webhook_url, message)
  end

  private

  def build_message(user, vehicle)
    if vehicle.lease_expiry.present?
      create_message(
        title: "#{user.name}様の車両のリース満了日が近づいています",
        text: "次回のリース満了日は#{vehicle.lease_expiry}です。お忘れなく、適切な手続きを行ってください。",
        vehicle: vehicle
      )
    elsif vehicle.inspection_due.present?
      create_message(
        title: "#{user.name}様の車両の車検期限が近づいています",
        text: "次回の車検期限は#{vehicle.inspection_due}です。お忘れなく、適切な手続きを行ってください。",
        vehicle: vehicle
      )
    end
  end

  def create_message(title:, text:, vehicle:)
    {
      "@type" => "MessageCard",
      "@context" => "http://schema.org/extensions",
      "summary" => "Issue 176715375",
      "themeColor" => "0078D7",
      "title" => title,
      "sections" => [{
        "activityTitle" => "#{vehicle.maker} #{vehicle.model} #{vehicle.license_plate}",
        "text" => text,
        "markdown" => true
      }]
    }
  end

  def send_to_teams_webhook(webhook_url, message)
    url = URI(webhook_url)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url.request_uri, {'Content-Type' => 'application/json'})
    request.body = message.to_json

    response = http.request(request)
  end
end
