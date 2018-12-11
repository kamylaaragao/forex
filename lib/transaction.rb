require 'json'
require 'sqlite3'

class Transaction
  attr_accessor :id, :type, :currency, :price, :total_usd

  def initialize(id = nil, type, currency, price, total_usd)
    @type = type
    @currency = currency
    @price = price
    @total_usd = total_usd
    @id = id
  end

  def to_db
    db = SQLite3::Database.open "data/cambio.db"
    db.execute('INSERT INTO transactions(type, currency, price, total) VALUES (?, ?, ?, ?)',
    @type, @currency, @price, @total_usd)
    db.close
  end
end
