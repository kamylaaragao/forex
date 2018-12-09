require_relative 'transaction'

class Balance
  attr_accessor :price, :balance_d, :balance_r, :transactions, :active_transaction, :transaction_count

  def initialize
    puts 'Olá, por favor digite as informações abaixo'
    puts 'Cotação do dólar em reais: '
    @price = gets.to_f
    puts 'Dolares disponíveis no caixa: '
    @balance_d = gets.to_f
    puts 'Reais disponíveis no caixa: '
    @balance_r = gets.to_f
    @transaction_count = 0
    @transactions = []
  end

  def dollar_to_real(value)
    value * @price
  end

  def real_to_dollar(value)
    value / @price
  end

  def change_dollar(type, currency, dollar, real)
    @balance_d -= dollar
    @balance_r += real
    @transaction_count += 1
    @active_transaction = Transaction.new(type, currency, @price, dollar, @transaction_count)
    @transactions << @active_transaction
    puts 'Operacao confirmada!'
  end

  def change_real(type, currency, dollar, real)
    @balance_d += dollar
    @balance_r -= real
    @transaction_count += 1
    @active_transaction = Transaction.new(type, currency, @price, dollar, @transaction_count)
    @transactions << @active_transaction
    puts 'Operacao confirmada!'
  end

  def confirm_transaction(type, currency, dollar, real)
    if currency == 'USD'
      if type == 'compra' && dollar <= @balance_d
        change_dollar(type, currency, dollar, real)
      elsif type == 'venda' && real <= @balance_r
        change_real(type, currency, dollar, real)
      else
        puts 'Saldo insuficiente em caixa'
      end
    elsif currency == 'BRL'
      if type == 'venda' && dollar <= @balance_d
        change_dollar(type, currency, dollar, real)
      elsif type == 'compra' && real <= @balance_r
        change_real(type, currency, dollar, real)
      else
        puts 'Saldo insuficiente em caixa'
      end
    end
  end
end
