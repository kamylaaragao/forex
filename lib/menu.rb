require_relative 'Cashier'

class Menu

  BUY_DOLLAR = 1
  SELL_DOLLAR = 2
  BUY_REAL = 3
  SELL_REAL = 4
  SHOW_TRANSACTIONS = 5
  SHOW_BALANCE = 6
  CLOSE = 7

  def self.menu
    puts 'Escolha uma opção no menu:'
    puts "[#{BUY_DOLLAR}] Comprar dólares"
    puts "[#{SELL_DOLLAR}] Vender dólares"
    puts "[#{BUY_REAL}] Comprar reais"
    puts "[#{SELL_REAL}] Vender reais"
    puts "[#{SHOW_TRANSACTIONS}] Ver operações do dia"
    puts "[#{SHOW_BALANCE}] Ver situação do caixa"
    puts "[#{CLOSE}] Sair"
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
          if option == BUY_DOLLAR
            a = cashier.buy_usd_sell_brl('compra', 'USD', value, (value* price))
          elsif option == SELL_DOLLAR
            a = cashier.buy_brl_sell_usd('venda', 'USD', value, (value * price))
          elsif option == BUY_REAL
            a = cashier.buy_brl_sell_usd('compra', 'BRL', (value / price), value)
          elsif option == SELL_REAL
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
      elsif option == SHOW_TRANSACTIONS
        puts cashier.transactions_table
      elsif option == SHOW_BALANCE
        puts cashier.balance_table
      else
        print 'Opção invalida'
      end
      option = menu
    end
  end
end
