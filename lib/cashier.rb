require_relative 'transaction'
require 'rubygems'
require 'terminal-table/import'

class Cashier
  attr_accessor :cashier_id, :price, :balance_usd, :balance_brl, :date, :transactions, :active_transaction

  def initialize(cashier_id = nil, date = Date.today.to_s, balance_usd, balance_brl, price)
    @cashier_id = cashier_id
    @price = price
    @balance_usd = balance_usd
    @balance_brl = balance_brl
    @date = date
  end

  def update?
    puts 'Deseja atualizar as informações? [s/n]'
    r = gets.chomp
    return true if r == 's'
    false
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

  def select_transactions
    @transactions = []
    db = SQLite3::Database.open 'data/cambio.db'
    db.execute('select * from transactions') do |row|
      @active_transaction = Transaction.new(row[0].to_i, row[1], row[2], row[3].to_f, row[4].to_f)
      @transactions << @active_transaction
    end
    db.close
    @transactions
  end

  def update_db
    db = SQLite3::Database.open "data/cambio.db"
    db.execute('update cashier set balance_usd = ?, balance_brl = ?, price = ? where date = ?',
    @balance_usd, @balance_brl, @price, @date)
    db.close
  end

  def create_transaction(type, currency, dollar)
    @active_transaction =Transaction.new(type, currency, @price, dollar)
    @active_transaction.to_db(@cashier_id)
    true
  end

  def buy_usd_sell_brl(type, currency, dollar, real)
    if real <= @balance_usd
      @balance_usd -= dollar
      @balance_brl += real
      update_db
      create_transaction(type, currency, dollar)
    else
      false
    end
  end

  def buy_brl_sell_usd(type, currency, dollar, real)
    if real <= @balance_brl
      @balance_usd += dollar
      @balance_brl -= real
      update_db
      create_transaction(type, currency, dollar)
    else
      false
    end
  end

  def to_db
    db = SQLite3::Database.open "data/cambio.db"
    db.execute('insert into cashier (date, balance_usd, balance_brl, price) values (?, ?, ?, ?)',
    @date, @balance_usd, @balance_brl, @price)
    @cashier_id = db.execute('select cashier_id from cashier where (date = ?)', @date)
    db.close
  end

  def balance_table
    balance = table do |t|
      t.headings = 'Data', 'Cotação do dia', 'Total USD no caixa', 'Total BRL no caixa'
      t << [@date, @price, @balance_usd, @balance_brl]
    end
  end

  def transactions_table
    select_transactions
    transac = table do |t|
      t.headings = 'ID', 'Tipo', 'Moeda', 'Cotação', 'Total em USD'
      for i in @transactions
        t << [i.transaction_id, i.type, i.currency, i.price, i.total_usd]
        puts i.transaction_id
      end
    end
  end
end
