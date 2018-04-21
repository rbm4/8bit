class StaticPagesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:index]
    def index
        if  params[:currency].nil?
            @currency = "BTC"
        else
            @currency = params[:currency]
        end
        @cost = COST[:"#{@currency}"]
        @tickets = Ticket.where("active = :vld AND currency = :crr", {vld: true, crr: @currency})
        if !(@tickets.empty?)
            total_size = 0
            @tickets.each do |t|
                total_size = total_size + Integer(t.size)
            end
            @total = total_size
        else
            @total = 0
        end
    end
    def buy_ticket
        if Integer(buy_params[:amount]) <= 0
            @invalid = true
            @message = "Insira um número válido de tickets."
            return
        end
        if (buy_params[:wallet].to_s) == ""
            @invalid = true
            @message = "Insira uma carteira para receber as moedas."
            return
        end
        if Shapeshiftio.validate("#{buy_params[:wallet]}",buy_params[:currency])["isvalid"]
            @pay = Payment.new
            @pay.amount_tck = buy_params[:amount]
            @pay.address_receive = buy_params[:wallet]
            @pay.currency = buy_params[:currency]
            @pay.status = "pendente"
            @pay.address_payment = Coinpayments.get_callback_address(@pay.currency, options = { ipn_url: "https://#{ENV['BASE_URL']}/#{ENV['COINPAYMENTS_ROUTE']}"}).address
            @pay.save
            envio = (COST[:"#{@pay.currency}"]).truncate(8) * BigDecimal(@pay.amount_tck).truncate(8)
            @qr = RQRCode::QRCode.new( "#{@pay.currency}:#{@pay.address_payment}?amount=#{envio}")
            @invalid = false
            @message = "Compra iniciada, envie: <b>#{envio} #{@pay.currency}</b> para o endereço: <br><b>#{@pay.address_payment}</b><br>No momento que a quantidade de moedas especificado acima chegar no endereço indicado, seus tickets automaticamente entrarão no sorteio!"
        else
            @invalid = true
            @message = "Carteira inválida para essa moeda!"
        end
    end
    def buy_params
        params.permit(:wallet,:amount,:currency)
    end
end
