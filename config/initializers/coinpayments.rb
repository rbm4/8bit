Coinpayments.configure do |config|
  config.merchant_id     = ENV['CPAY_ID']
  config.public_api_key  = ENV['CPAY_PUBLIC']
  config.private_api_key = ENV['CPAY_PRIVATE']
end