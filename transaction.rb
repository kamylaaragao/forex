class Transaction
  attr_accessor :id, :type, :currency, :price, :total_usd

  def initialize(type, currency, price, total_usd)
    @type = type
    @currency = currency
    @price = price
    @total_usd = total_usd
  end
end
