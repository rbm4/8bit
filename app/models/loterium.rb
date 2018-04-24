class Loterium < ApplicationRecord
    require 'sendgrid-ruby'
    include SendGrid


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
    def notify_lot_result(currencies,key)
        k = Deliver.all
        from = Email.new(email: 'loteria@bit8.se')
        time = Time.now
        ultimo_sorteio = Sorteio.order("created_at").last
        premiados = ultimo_sorteio.premiado.all
        string_corpo_email = "Olá! <br> Obrigado por utilizar os serviços de loteria da 8bit. Você está recebendo esse email por ter se inscrito no nosso canal de notificações!"
        string_corpo_email << "<br>Ganhadores da rodada de sorteios atual, se você não ganhou agora, não desista! Você pode jogar a qualquer momento, é simples e rápido. Acesse agora: <a href='https://bit8.herokuapp.com'>Acesse agora</a>:"
        currencies.each do |currency|
            string_corpo_email << "<br>-> #{currency}:"
            premiados.each do |premiado|
                if premiado.currency == currency
                    string_corpo_email << "<br>#{premiado.wallet}: #{premiado.qtd} #{currency}"
                end
            end
        end
        
        
        string_time = time.strftime("%d/%m/%Y").to_s
        subject = "Sorteio #{string_time} - 8Bit Loteria"
        k.each do |deliver|
            
            to = Email.new(email: deliver.email)
            content = Content.new(type: 'text/plain', value: string_corpo_email)
            mail = Mail.new(from, subject, to, content)
            
            sg = SendGrid::API.new(api_key: key)
            response = sg.client.mail._('send').post(request_body: mail.to_json)
            puts response.status_code
            puts response.body
            puts response.headers
            sleep 0.5
        end
    
    end
    
end
