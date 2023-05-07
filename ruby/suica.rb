class Suica
  attr_reader :balance

  def initialize
    @balance = 0
    charge(500)
  end

  def charge(deposit)
    if deposit > 100
      @balance += deposit
      "charge後の残高: #{@balance}"
    else
      "100¥未満はchargeできません"
    end
  end

  def purchase(drink)
    # TODO purchase(drink)の実装
  end

  def show_balance()
    "現在の残高: #{@balance}"
  end
end

my_suica = Suica.new
my_suica.charge(1)
p my_suica.show_balance
p my_suica.balance
