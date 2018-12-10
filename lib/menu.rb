require_relative 'balance'

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
    balance_brz = gets.to_f
    balance = Balance.new(price, balance_usd, balance_brz)
    option = menu
    while option != 7
      puts "Opção escolhida: #{option}"
      if option > 0 && option < 5
        puts 'Informe o valor da transação: '
        if option == 1 || option == 2
          dollar = gets.to_f
          real = balance.dollar_to_real(dollar)
          currency = 'USD'
          if option == 1
            type = 'compra'
          elsif option == 2
            type = 'venda'
          end
          puts "Valor a ser pago pela #{type} de USD #{dollar}: BRL #{real}"
        elsif option == 3 || option == 4
          real = gets.to_f
          dollar = balance.real_to_dollar(real)
          currency = 'BRL'
          if option == 3
            type = 'compra'
          elsif option == 4
            type = 'venda'
          end
          puts "Valor a ser pago pela #{type} de BRL #{real}: USD #{dollar}"
        end
        puts 'Deseja confirmar a operação? [s/n]'
        r = gets.chomp
        if r == 's'
          if balance.confirm_transaction(type, currency, dollar, real)
            puts 'Operacao confirmada!'
          else
            puts 'Saldo indisponivel em caixa'
          end
        else
          puts 'Operacao cancelada'
        end
      elsif option == 5
        puts balance.transactions_table
      elsif option == 6
        puts balance.balance_table
      else
        print 'Opção invalida'
      end
      option = menu
    end
  end
end
