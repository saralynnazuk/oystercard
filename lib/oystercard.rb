require './lib/station'

class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  attr_reader :balance, :in_journey, :journey

  def initialize
    @balance = 0
    @in_journey = false
    @journey = {}
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
    @journey[:entry_station] = station.name
  end

  def touch_out(station)
    deduct
    @in_journey = false
    @journey[:exit_station] = station.name
  end

  private

  def deduct
    @balance -= MINIMUM_FARE
  end

end
