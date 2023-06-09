class Suica

  def initialize
    @balance = 0
    charge(500)
  end

  def balance
    @balance
  end

  def charge(deposit)
    raise '100¥未満はchargeできません' unless deposit > 100

    @balance += deposit
    "charge後の残高: #{@balance}¥"
  end

  def purchase(drink_price)
    raise "残高が足りません!" if @balance < drink_price

    @balance -= drink_price
  end

  def show_balance
    "現在の残高: #{@balance}¥"
  end
end
