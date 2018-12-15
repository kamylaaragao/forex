require 'sqlite3'

class Transaction
  attr_accessor :transaction_id, :type, :currency, :price, :total_usd

  def initialize(transaction_id = nil, type, currency, price, total_usd)
    @type = type
    @currency = currency
    @price = price
    @total_usd = total_usd
    @transaction_id = transaction_id
  end

  def to_db (cashier_id)
    db = SQLite3::Database.open "data/cambio.db"
    db.execute('INSERT INTO transactions(type, currency, price, total, cashier_id) VALUES (?, ?, ?, ?, ?)',
    @type, @currency, @price, @total_usd, cashier_id)
    db.close
  end

  def self.confirm?
    puts 'Deseja confirmar a operação? [s/n]'
    r = gets.chomp
    return true if r == 's'
    false
  end
end
