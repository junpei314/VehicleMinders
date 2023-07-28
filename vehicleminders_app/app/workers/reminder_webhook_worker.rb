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
    # Teams の Webhook URL
    url = URI(user.webhook_url)

    # メッセージの内容
    message = {
      "@type" => "MessageCard",
      "@context" => "http://schema.org/extensions",
      "summary" => "Issue 176715375",
      "themeColor" => "0078D7",
      "title" => "#{user.name}様の車両の車検期限が近づいています",
      "sections" => [{
        "activityTitle" => "#{vehicle.maker} #{vehicle.model} #{vehicle.license_plate}",
        "text" => "次回の車検期限は#{vehicle.inspection_due}です。お忘れなく、適切な手続きを行ってください。",
        "markdown" => true
      }]
    }

    # HTTP クライアントを作成
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    # POST リクエストを作成
    request = Net::HTTP::Post.new(url.request_uri, {'Content-Type' => 'application/json'})
    request.body = message.to_json

    # POST リクエストを送信
    response = http.request(request)

    # レスポンスのステータスコードを表示
    puts response.code
  end
end
