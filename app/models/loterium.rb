class Loterium < ApplicationRecord
    def configure_cpay(keys)
        Coinpayments.configure do |config|
          config.merchant_id     = keys[:CPAY_ID]
          config.public_api_key  = keys[:CPAY_PUBLIC]
          config.private_api_key = keys[:CPAY_PRIVATE]
        end
        p Coinpayments.balances[:"DOGE"][:balancef]
    end
    def get_saldo(cur)
        p cur
        Coinpayments.balances({"all": 1})[:"#{cur}"][:balancef]
    end
end
