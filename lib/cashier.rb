require_relative 'transaction'
require 'rubygems'
require 'terminal-table/import'

class Cashier
  attr_accessor :price, :balance_usd, :balance_brl, :transactions, :active_transaction, :transaction_count

  def initialize(price, balance_usd, balance_brl)
    @price = price
    @balance_usd = balance_usd
    @balance_brl = balance_brl
    @transaction_count = 0
    @transactions = []
  end

  def payment_to_s(option, value)
    if option == 1 || option == 2
      real = value * @price
      "Valor a ser pago: BRL #{real}"
    elsif option == 3 || option == 4
      dollar = value / @price
      "Valor a ser pago: USD #{dollar}"
    end
  end

  def confirm?
    puts 'Deseja confirmar a operação? [s/n]'
    r = gets.chomp
    return true if r == 's'
    false
  end

  def create_transaction(type, currency, dollar, real)
    @active_transaction = Transaction.new(type, currency, @price, dollar, @transaction_count)
    @transactions << @active_transaction
    r = true
  end

  def buy_usd_sell_brl(type, currency, dollar, real)
    if real <= @balance_usd
      @balance_usd -= dollar
      @balance_brl += real
      @transaction_count += 1
      create_transaction(type, currency, dollar, real)
    else
      r = false
    end
  end

  def buy_brl_sell_usd(type, currency, dollar, real)
    if real <= @balance_brl
      @balance_usd += dollar
      @balance_brl -= real
      @transaction_count += 1
      create_transaction(type, currency, dollar, real)
    else
      r = false
    end
  end

  def balance_table
    transac = table do |t|
      t.headings = 'Cotação do dia', 'total USD no caixa', 'total BRL no caixa'
      t << [@price, @balance_usd, @balance_brl]
    end
  end

  def transactions_table
    transac = table do |t|
      t.headings = 'id', 'tipo', 'moeda', 'total em USD'
      for i in @transactions
        t << [i.id, i.type, i.currency, i.total_usd]
      end
    end
  end
end
