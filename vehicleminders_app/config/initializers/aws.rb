if Rails.env.production?
  Aws.config.update({
    region: 'ap-northeast-1'
  })
end
