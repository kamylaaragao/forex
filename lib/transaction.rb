class Transaction
  attr_accessor :id, :type, :currency, :price, :total_usd

  def initialize(type, currency, price, total_usd, id)
    @type = type
    @currency = currency
    @price = price
    @total_usd = total_usd
    @id = id
  end

  def to_s
    "ID: #{@id}; type: #{@type}; currency: #{@currency}; total USD: #{@total_usd}; total BRL: #{@total_usd * @price}"
  end
end
