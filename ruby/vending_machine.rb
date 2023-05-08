require_relative './drink'
require_relative './suica'

class VendingMachine
  @@earnings = 0

  def initialize
    @earning = 0
    @stock = {}
    @selected_drink = :none

    refill(drink: :pepshi, quantity: 5)
    refill(drink: :monster, quantity: 5)
    refill(drink: :irohasu, quantity: 5)
  end

  def self.earnings
    @@earnings
  end

  def earning
    @earning
  end

  def stock
    @stock
  end

  def selected_drink
    @selected_drink
  end

  def selected_drink=(value)
    @selected_drink = value
  end

  def show_available_drink
    @stock.map do |key, value|
      value.empty? ? nil : key
    end.join(',')
  end

  def select(drink)
    raise '在庫がありません' unless available?(drink)

    @selected_drink = drink
    "#{@selected_drink}が選択されています"
  end

  def touch(suica)
    raise 'drinkを選択してください' if @selected_drink == :none

    purchase(suica) if purchasable?(suica)
  end

  def purchase(suica)
    if suica.purchase(drink_price)
      @earning += drink_price
      @@earnings += drink_price
    end
    purchased_drink = release_drink
    @selected_drink = :none
    "#{purchased_drink.name}を#{purchased_drink.price}で購入しました。残高は#{suica.balance}¥です"
  end

  def refill(drink: :pepshi, quantity: 1)
    quantity.times { put_on(drink) }
    show_stock
  end

  def show_stock
    @stock.map do |key, value|
      "#{key}の在庫は#{value.size}個です"
    end.join(',')
  end

  private

  def purchasable?(suica)
    raise '在庫がありません！' unless available?(@selected_drink)
    raise 'お金が足りません！' unless enough_money?(suica)

    # 在庫がある && 残高も足りている
    available?(@selected_drink) && enough_money?(suica)
  end

  def available?(drink)
    show_available_drink.include?(drink.to_s)
  end

  def drink_price
    case @selected_drink
    in :pepshi
      drink_price = @stock[:pepshi][-1].price
    in :monster
      drink_price = @stock[:monster][-1].price
    in :irohasu
      drink_price = @stock[:irohasu][-1].price
    end
    drink_price
  end

  def enough_money?(suica)
    suica.balance >= drink_price
  end

  def put_on(drink)
    case drink
    in :pepshi
      @stock[:pepshi] ||= []
      drink = Drink.new(:pepshi,150)
      @stock[:pepshi] << drink
    in :monster
      @stock[drink] ||= []
      drink = Drink.new(:monster,230)
      @stock[:monster] << drink
    in :irohasu
      @stock[drink] ||= []
      drink = Drink.new(:irohasu,120)
      @stock[:irohasu] << drink
    end
  end

  def release_drink
    @stock[@selected_drink].shift
  end
end

my_suica = Suica.new
p '---- my_suica.balance ----'
p my_suica.balance
p ''

vm = VendingMachine.new
p '---- vm.show_available_drink ----'
p vm.show_available_drink
p ''
p '---- vm.select(:pepshi) ----'
p vm.select(:pepshi)
p ''
p '---- vm.touch(my_suica) ----'
p vm.touch(my_suica)
p ''

p '---- my_suica.balance ----'
p my_suica.balance
p ''
p '---- my_suica.balance ----'
p vm.show_stock
p ''

p '---- vm.select(:pepshi) ----'
p vm.select(:pepshi)
p ''
p '---- vm.touch(my_suica) ----'
p vm.touch(my_suica)
p ''

p '---- vm.select(:pepshi) ----'
p vm.select(:pepshi)
p ''
p '---- vm.touch(my_suica) ----'
p vm.touch(my_suica)
p ''

# p '---- vm.select(:irohasu) ----'
# p vm.select(:irohasu)
# p ''
# p '---- vm.touch(my_suica) ----'
# p vm.touch(my_suica)
# p ''
#=> ruby/vending_machine.rb:65:in `purchasable?': お金が足りません！ (RuntimeError)

# p '---- my_suica.balance ----'
# p my_suica.charge(70)
# p ''
#=> ruby/suica.rb:10:in `charge': 100¥未満はchargeできません (RuntimeError)

p '---- my_suica.balance ----'
p my_suica.charge(1000)
p ''

p '---- vm.select(:pepshi) ----'
p vm.select(:pepshi)
p ''
p '---- vm.touch(my_suica) ----'
p vm.touch(my_suica)
p ''

p '---- vm.select(:pepshi) ----'
p vm.select(:pepshi)
p ''
p '---- vm.touch(my_suica) ----'
p vm.touch(my_suica)
p ''

# p '---- vm.select(:pepshi) ----'
# p vm.select(:pepshi)
# p ''
# p '---- vm.touch(my_suica) ----'
# p vm.touch(my_suica)
# p ''
#=> ruby/vending_machine.rb:31:in `select': 在庫がありません (RuntimeError)

p '---- vm.show_stock ----'
p vm.show_stock
p ''
p '---- vm.show_available_drink ----'
p vm.show_available_drink
p ''

p 'vm.refill(drink: :pepshi, quantity: 3)'
p vm.refill(drink: :pepshi, quantity: 3)
p ''
p '---- vm.show_available_drink ----'
p vm.show_available_drink
p ''
p '---- vm.earning ----'
p vm.earning
p '---- vm.earnings ----'
p vm.class.earnings

vm2 = VendingMachine.new
p '---- vm.select(:monster) ----'
p vm2.select(:monster)
p ''
p '---- vm.touch(my_suica) ----'
p vm2.touch(my_suica)
p ''

p '---- vm2.earning ----'
p vm2.earning
p '---- vm2.earnings ----'
p vm2.class.earnings
