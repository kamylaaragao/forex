require_relative 'transaction'
require 'rubygems'
require 'terminal-table/import'

class Cashier
  attr_accessor :price, :balance_usd, :balance_brl, :transactions, :active_transaction

  def initialize(price, balance_usd, balance_brl)
    @price = price
    @balance_usd = balance_usd
    @balance_brl = balance_brl
    @transactions = []
  end

  def payment_to_s(option, value)
    if option == Menu::BUY_DOLLAR|| option == Menu::SELL_DOLLAR
      real = value * @price
      "Valor a ser pago: BRL #{real}"
    elsif option == Menu::BUY_REAL || option == Menu::SELL_REAL
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

  def select_transactions
    db = SQLite3::Database.open 'data/cambio.db'
    db.execute('SELECT * FROM TRANSACTIONS') do |row|
      @active_transaction = Transaction.new(row[0].to_i, row[1], row[2], row[3].to_f, row[4].to_f)
      @transactions << @active_transaction
    end
    db.close
    @transactions
  end

  def create_transaction(type, currency, dollar)
    @active_transaction =Transaction.new(type, currency, @price, dollar)
    @active_transaction.to_db
    true
  end

  def buy_usd_sell_brl(type, currency, dollar, real)
    if real <= @balance_usd
      @balance_usd -= dollar
      @balance_brl += real
      create_transaction(type, currency, dollar)
    else
      false
    end
  end

  def buy_brl_sell_usd(type, currency, dollar, real)
    if real <= @balance_brl
      @balance_usd += dollar
      @balance_brl -= real
      create_transaction(type, currency, dollar)
    else
      false
    end
  end

  def balance_table
    transac = table do |t|
      t.headings = 'Cotação do dia', 'total USD no caixa', 'total BRL no caixa'
      t << [@price, @balance_usd, @balance_brl]
    end
  end

  def transactions_table
    select_transactions
    transac = table do |t|
      t.headings = 'id', 'tipo', 'moeda', 'cotação USD/BRL','total em USD'
      for i in @transactions
        t << [i.id, i.type, i.currency, i.price, i.total_usd]
      end
    end
  end
end
