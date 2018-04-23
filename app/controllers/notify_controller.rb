class NotifyController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:confirm_transaction]
    def confirm_transaction #/notify/cpay
        @payment = Payment.find_by_address_payment(params["address"])
        if (@payment.nil? or params["merchant"] != ENV["CPAY_ID"] or params["ipn_type"] != "deposit" or @payment.status == "completo" )
            render status: :ok
            return
        end    
        case params["status"]
        when "0"
            
            @payment.status = "pendente"
        when "100" 
            if BigDecimal(params["amount"],8) >= BigDecimal(BigDecimal(@payment.amount_tck) * COST[:"#{params[:currency]}"])
                @payment.status = "completo"
                @ticket = Ticket.where("wallet = :addr and active = :act", { addr: @payment.address_receive, act: true})
                if @ticket.empty?
                    tck = Ticket.new
                    tck.size = @payment.amount_tck
                    tck.active = true
                    tck.wallet = @payment.address_receive
                    tck.currency = @payment.currency
                else
                    tck = @ticket.first
                    tck.size = Integer(tck.size) + Integer(@payment.amount_tck)
                end
                tck.save
            elsif @payment.status != "completo" and BigDecimal(params["amount"],8) <= BigDecimal(BigDecimal(@payment.amount_tck) * COST[:"#{params[:currency]}"])
                @payment.status = "parcial"
                @ticket = Ticket.where("wallet = :addr and active = :act", { addr: @payment.address_receive, act: true})
                amount = (BigDecimal(params["amount"],8) / BigDecimal(COST[:"#{params[:currency]}"])).floor
                if @ticket.empty?
                    tck = Ticket.new
                    tck.size = amount
                    tck.active = true
                    tck.wallet = @payment.address_receive
                    tck.currency = @payment.currency
                    @payment.amount_tck = Integer(@payment.amount_tck) - Integer(amount)
                else
                    tck = @ticket.first
                    tck.size = Integer(tck.size) + Integer(amount)
                end
                tck.save
                # TODO: pagamento de ticket parcial
            end
            @payment.save
        end
        render status: :ok
    end
end
