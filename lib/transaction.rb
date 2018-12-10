require 'json'

class Transaction
  attr_accessor :id, :type, :currency, :price, :total_usd

  def initialize(type, currency, price, total_usd, id)
    @type = type
    @currency = currency
    @price = price
    @total_usd = total_usd
    @id = id
    save_to_file
  end

  def to_s
    "ID: #{@id}; type: #{@type}; currency: #{@currency}; total USD: #{@total_usd}; total BRL: #{@total_usd * @price}"
  end

  def to_json
    x = {:id => @id,  :type => @type, :currency => @currency, :price => @price, :total_usd => "#{@total_usd} \n"}
    x.to_json
  end

  def save_to_file
    File.open('data/transaction.json', 'a') do |f|
      f.print to_json
      f.puts '\r'
    end
  end
end
