require_relative 'transaction'

class Balance
  attr_accessor :price, :balance_usd, :balance_brz, :transactions, :active_transaction, :transaction_count

  def initialize(price, balance_usd, balance_brz)
    @price = price
    @balance_usd = balance_usd
    @balance_brz = balance_brz
    @transaction_count = 0
    @transactions = []
  end

  def dollar_to_real(value)
    value * @price
  end

  def real_to_dollar(value)
    value / @price
  end

  def to_s
    "Cotação do dia #{@price} total USD no caixa: #{@balance_usd}; total BRL no caixa: #{@balance_brz}"
  end

  def create_transaction(type, currency, dollar, real)
    @active_transaction = Transaction.new(type, currency, @price, dollar, @transaction_count)
    @transactions << @active_transaction
    r = true
  end

  def change_dollar(type, currency, dollar, real)
    @balance_usd -= dollar
    @balance_brz += real
    @transaction_count += 1
    create_transaction(type, currency, dollar, real)
  end

  def change_real(type, currency, dollar, real)
    @balance_usd += dollar
    @balance_brz -= real
    @transaction_count += 1
    create_transaction(type, currency, dollar, real)
  end

  def confirm_transaction(type, currency, dollar, real)
    if currency == 'USD'
      if type == 'compra' && dollar <= @balance_usd
        change_dollar(type, currency, dollar, real)
      elsif type == 'venda' && real <= @balance_brz
        change_real(type, currency, dollar, real)
      else
        r = false
      end
    elsif currency == 'BRL'
      if type == 'venda' && dollar <= @balance_usd
        change_dollar(type, currency, dollar, real)
      elsif type == 'compra' && real <= @balance_brz
        change_real(type, currency, dollar, real)
      end
    end
  end
end
