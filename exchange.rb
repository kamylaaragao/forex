require_relative 'balance'

transactions = []

if File.exists?("./transactions.txt") == true
  transaction_list = File.open("./transaction.txt", "r")
  transactions = Marshal::load(transaction_list)
end

Balance.open_balance

option = Balance.menu()

while option != 7 do
  puts "Opção escolhida: #{option}"
  r = nil
  if option > 0 && option < 5
    puts 'informe o valor da transação: '
    if option == 1 || option == 2
      dollar = gets.to_f
      real = Balance.dollar_to_real(dollar)
      currency = 'USD'
      if option == 1
        type = 'compra'
      elsif option == 2
        type = 'venda'
      end
      puts "Valor a ser pago pela #{type} de USD #{dollar}: BRL #{real}"
    elsif option == 3 || option == 4
      real = gets.to_f
      dollar = Balance.real_to_dollar(real)
      currency = 'BRL'
      if option == 3
        type = 'compra'
      elsif option == 4
        type = 'venda'
      end
      puts "Valor a ser pago pela #{type} de BRL #{real}: USD #{dollar}"
    end
    puts ''
    puts 'deseja confirmar a operação? [s/n]'
    puts ''
    r = gets.chomp
    if (r == 's')
      Balance.confirm_transaction(type, currency, dollar, real)
    else
      puts 'operacao cancelada'
    end
  else
    print 'Opção invalida'
  end
  option = Balance.menu()
end
