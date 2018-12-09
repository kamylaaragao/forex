require_relative 'transaction'

class Balance
  attr_accessor :price, :balance_d, :balance_r, :transactions, :active_transaction

  def self.menu()
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

  def self.open_balance
    puts 'Olá, por favor digite as informações abaixo'
    puts 'Cotação do dólar em reais: '
    @price = gets.to_f
    puts 'Dolares disponíveis no caixa: '
    @balance_d = gets.to_f
    puts 'Reais disponíveis no caixa: '
    @balance_r = gets.to_f
  end

  def self.dollar_to_real (value)
    value * @price
  end

  def self.real_to_dollar (value)
    value / @price
  end

  def self.change_dollar(type, currency, dollar, real)
    @balance_d -= dollar
    @balance_r += real
    @active_transaction = Transaction.new(type, currency, @price, dollar)
    puts 'operacao confirmada!'
  end

  def self.change_real(type, currency, dollar, real)
    @balance_d += dollar
    @balance_r -= real
    @active_transaction = Transaction.new(type, currency, @price, dollar)
    puts 'operacao confirmada!'
  end

  def self.confirm_transaction(type, currency, dollar, real)
    if currency == 'USD'
      if type == 'compra' && dollar <= @balance_d
        change_dollar(type, currency, dollar, real)
      elsif type == 'venda' && real <= @balance_r
        change_real(type, currency, dollar, real)
      else
        puts''
        puts 'Saldo insuficiente em caixa'
        puts''
      end
    elsif currency == 'BRL'
      if type == 'venda' && dollar <= @balance_d
        change_dollar(type, currency, dollar, real)
     elsif type == 'compra' && real <= @balance_r
        change_real(type, currency, dollar, real)
      else
        puts''
        puts 'Saldo insuficiente em caixa'
        puts''
      end
    end
    puts "real disponivel no caixa #{@balance_r}"
    puts "dolar disponivel no caixa #{@balance_d} "
  end

end
