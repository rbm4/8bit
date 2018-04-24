task :roll_lotterys, [:private, :id, :public, :sendgrid] => :environment do |t, chave|
    # parâmetros de sorteio
    currencies = ["BTC","DOGE","LTC","ETH","DASH","BCH","DGB", "GRC"]
    proportions = [0.40,0.20,0.10,0.08,0.06,0.05,0.04,0.03,0.02,0.01]
    cost = {BTC: BigDecimal("0.001"), DOGE: BigDecimal("1"), LTC: BigDecimal("0.004"), BCH: BigDecimal("0.0004"), DASH: BigDecimal("0.002"), ETH: BigDecimal("0.0024"), DGB: BigDecimal("0.002"),  GRC: BigDecimal("0.0002")}
    chave.with_defaults(:private => "default_secret_value", :id => "default_id_value", :public => "default_public_value" ,:sendgrid => "default_sendgrid_value")
    loterium = Loterium.new
    loterium.configure_cpay({"CPAY_ID": chave.id, "CPAY_PRIVATE": chave.private, "CPAY_PUBLIC":  chave.public})
    if Time.now.strftime("%d") == "1"
        sorteio = Sorteio.new
        sorteio.save
        puts "data correta"
        currencies.each do |cur|
            valor_inicial = BigDecimal(loterium.get_saldo(cur))
            p "moeda: #{cur}"
            tickets = Ticket.where("active = :act and currency = :crr", {act: true, crr: cur})
            total_sorteavel = 0
            usuarios = []                   #wallets que podem receber o premio sem repetição
            contador = 0
            piscina_tickets = Array.new     #array de wallets a serem premiadas, com proporção
            tickets.each do |h|
                usuarios[contador] = h.wallet
                Integer(h.size).times do
                    piscina_tickets << h.wallet
                end
                total_sorteavel = Integer(total_sorteavel) + Integer(h.size)
                contador = contador + 1
            end
            position = 1
            proporcoes_premios = proportions
            proporcoes_premios.each do |k|
                premiado = rand(0...total_sorteavel)
                premio_string = ((valor_inicial * k) * 0.995 ).truncate(8).to_s
                puts "premio = #{premio_string}"
                if !(piscina_tickets.empty?)
                    puts 'entregar premio'
                    if piscina_tickets[premiado] != nil
                        user_premiado = piscina_tickets[premiado]
                        j = Ticket.where(:active => true,  :wallet => user_premiado).first
                        p "Enviado #{cur} aqui para o ganhador #{user_premiado}, no valor de #{premio_string}, para o endereço #{piscina_tickets[premiado]}\n"
                        #registrar premio
                        a = sorteio.premiado.new
                        a.wallet = piscina_tickets[premiado]
                        a.qtd = premio_string
                        a.position = position
                        a.currency = cur
                        position += 1
                        result = Coinpayments.create_withdrawal(premio_string,cur,piscina_tickets[premiado], options = {auto_confirm: 1})
                        case result
                        when String
                            if result == "#{cur.upcase} is currently disabled!"
                                #{cur.upcase} encontra-se desativada temporariamente por instabilidade na rede.
                                a.premio_entregue = false
                            else
                                a.premio_entregue = false
                            end
                        else
                            a.premio_entregue = true
                        end
                        j.active = false
                        j.save
                        total_sorteavel = Integer(total_sorteavel) - Integer(j.size) #diminuir toda a proporção do ticket do sorteio
                        piscina_tickets.reject! { |n| n == user_premiado } #remover da piscina de sorteáveis todas as entradas a carteira do ganhador atual
                        a.save
                        sleep 0.5
                    else
                        puts "sem usuários para serem sorteados"
                    end
                end
            end
        end
        j = Ticket.where(:active => true)
        j.each do |g|
            g.active = false
            g.save
        end
        p "Sorteio concluído"
        loterium.notify_lot_result(currencies, chave.sendgrid)
    else
        p "data errada, não fazer nada"
    end
end

task :deliver_prizes, [:private, :id, :public] => :environment do |t, chave|
    prizes = Premiado.where(premio_entregue => false)
    prizes.each do |a|
        result = Coinpayments.create_withdrawal(premio_string,cur,piscina_tickets[premiado], options = {auto_confirm: 1})
        case result
        when String
            if result == "#{cur.upcase} is currently disabled!"
                #{cur.upcase} encontra-se desativada temporariamente por instabilidade na rede.
                a.premio_entregue = false
            else
                a.premio_entregue = false
            end
        else
            a.premio_entregue = true
            a.save
        end
    end
end