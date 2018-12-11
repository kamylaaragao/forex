require_relative 'Cashier'

class Menu
  def self.menu
    puts 'Escolha uma opção no menu:'
    puts '[1] Comprar dólares'
    puts '[2] Vender dólares'
    puts '[3] Comprar reais'
    puts '[4] Vender reais'
    puts '[5] Ver operações do dia'
    puts '[6] Ver situação do caixa'
    puts '[7] Sair'
    gets.to_i
  end

  def self.start
    puts 'Olá, por favor digite as informações abaixo'
    puts 'Cotação do dólar em reais: '
    price = gets.to_f
    puts 'Dolares disponíveis no caixa: '
    balance_usd = gets.to_f
    puts 'Reais disponíveis no caixa: '
    balance_brl = gets.to_f
    cashier = Cashier.new(price, balance_usd, balance_brl)
    option = menu
    while option != 7
      puts "Opção escolhida: #{option}"
      if option > 0 && option < 5
        puts 'Informe o valor da transação: '
        value = gets.to_f
        puts cashier.payment_to_s(option, value)
        if cashier.confirm?
          if option == 1
            a = cashier.buy_usd_sell_brl('compra', 'USD', value, (value* price))
          elsif option == 2
            a = cashier.buy_brl_sell_usd('venda', 'USD', value, (value * price))
          elsif option == 3
            a = cashier.buy_brl_sell_usd('compra', 'BRL', (value / price), value)
          elsif option == 4
            a = cashier.buy_usd_sell_brl('venda', 'BRL', (value / price), value)
          end
          if a == true
            puts 'Operacao confirmada!'
          else
            puts 'Saldo indisponivel em caixa'
          end
        else
          puts 'Operacao cancelada'
        end
      elsif option == 5
        puts cashier.transactions_table
      elsif option == 6
        puts cashier.balance_table
      else
        print 'Opção invalida'
      end
      option = menu
    end
  end
end
