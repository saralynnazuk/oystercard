class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  attr_reader :balance, :in_journey, :entry_station, :exit_station, :journeys

  def initialize
    @balance = 0
    @in_journey = false
    @journeys = []
  end

  def top_up(amount)
    fail "Maximum balance of £#{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !!@in_journey
  end

  def touch_in(station)
    raise "Insufficient funds, please top up!" if balance < MINIMUM_BALANCE
    @in_journey = true
    @entry_station = station.name
  end

  def touch_out(station)
    deduct
    @in_journey = false
    @exit_station = station.name
  end

  private

  def deduct
    @balance -= MINIMUM_FARE
  end

end
