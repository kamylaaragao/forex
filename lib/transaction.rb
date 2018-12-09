class Transaction
  attr_accessor :id, :type, :currency, :price, :total_usd

  def initialize(type, currency, price, total_usd, id)
    @type = type
    @currency = currency
    @price = price
    @total_usd = total_usd
    @id = id
  end
end
