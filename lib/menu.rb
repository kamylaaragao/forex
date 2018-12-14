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

  def self.select_cashier(date)
    db = SQLite3::Database.open 'data/cambio.db'
    cashier = nil
    db.execute('select * from cashier where (date = ?)', date) do |row|
      cashier = Cashier.new(row[0].to_i, row[1], row[2].to_f, row[3].to_f, row[4].to_f, row[5])
    end
    db.close
    cashier
  end

  def self.get_cashier_information
    puts 'Nome do operador de caixa: '
    name = gets
    puts 'Cotação do dólar em reais: '
    price = gets.to_f
    puts 'Dolares disponíveis no caixa: '
    balance_usd = gets.to_f
    puts 'Reais disponíveis no caixa: '
    balance_brl = gets.to_f
    cashier = Cashier.new(balance_usd, balance_brl, price, name)
  end

  def self.start
    puts 'Olá, seja bem vindo!'
    cashier = select_cashier(Date.today.to_s)
    if cashier == nil
      cashier = get_cashier_information
      cashier.to_db
    else
      puts cashier.balance_table
      if cashier.update?
        cashier = get_cashier_information
        cashier.update_db
      end
    end
    option = menu
    while option != 7
      puts "Opção escolhida: #{option}"
      if option > 0 && option < 5
        puts 'Informe o valor da transação: '
        value = gets.to_f
        puts cashier.payment_to_s(option, value)
        if Transaction.confirm?
          if option == BUY_DOLLAR
            a = cashier.buy_usd_sell_brl('compra', 'USD', value, (value * cashier.price))
          elsif option == SELL_DOLLAR
            a = cashier.buy_brl_sell_usd('venda', 'USD', value, (value * cashier.price))
          elsif option == BUY_REAL
            a = cashier.buy_brl_sell_usd('compra', 'BRL', (value / cashier.price), value)
          elsif option == SELL_REAL
            a = cashier.buy_usd_sell_brl('venda', 'BRL', (value / cashier.price), value)
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
