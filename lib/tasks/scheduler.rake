task :roll_lotterys, [:secret, :key, :sendgrid] => :environment do |t, chave|
    # parâmetros de sorteio
    currencies = ["BTC","DOGE","LTC","ETH","DASH","BCH","DGB", "GRC"]
    proportions = [0.40,0.20,0.10,0.08,0.06,0.05,0.04,0.03,0.02,0.01]
    cost = {BTC: BigDecimal("0.00005"), DOGE: BigDecimal("1"), LTC: BigDecimal("0.0003"), BCH: BigDecimal("0.00005"), DASH: BigDecimal("0.0002"), ETH: BigDecimal("0.0002"), DGB: BigDecimal("0.3"),  GRC: BigDecimal("0.7")}
    chave.with_defaults(:secret => "default_secret_value", :key => "default_keyex_value", :sendgrid => "default_sendgrid_value")
    
    p chave
    #loterium = Loterium.new
    if Time.now.strftime("%d") == "21"
        puts "data correta"
        currencies.each do |cur|
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
            original_size = total_sorteavel
            proporcoes_premios = proportions
            proporcoes_premios.each do |k|
                premiado = rand(0...total_sorteavel)
                premio_string = ((BigDecimal(original_size) * cost[:"#{cur}"]) * k).truncate(8).to_s
                puts "premio = #{premio_string}"
                if !(piscina_tickets.empty?)
                    puts 'entregar premio'
                    if piscina_tickets[premiado] != nil
                        user_premiado = piscina_tickets[premiado]
                        j = Ticket.where(:active => true,  :wallet => user_premiado).first
                        p "Enviado #{cur} aqui para o ganhador #{user_premiado}, no valor de #{premio_string}, para o endereço #{piscina_tickets[premiado]}\n"
                        #eniar valor aqui
                        j.active = false
                        j.save
                        total_sorteavel = Integer(total_sorteavel) - Integer(j.size) #diminuir toda a proporção do ticket do sorteio
                        piscina_tickets.reject! { |n| n == user_premiado } #remover da piscina de sorteáveis todas as entradas a carteira do ganhador atual
                    else
                        puts "sem usuários para serem sorteados"
                    end
                end
            end
        end
        j = Ticket.where(:active => true)
        j.each do |g|
            g.sorteavel = false
            g.save
        end
        p "Sorteio concluído"
        # loterium.parabenizar_ganho(user_premiado, premio_string, chave.sendgrid) notificar usuários sobre 
    else
        p "data errada, não fazer nada"
    end
end