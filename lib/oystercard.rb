require './lib/station'
require_relative 'journey'

class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  attr_reader :balance, :in_journey, :history, :journey

  def initialize
    @balance = 0
    @history = []
    @journey = Journey.new
  end

  def top_up(amount)
    fail "Maximum balance of £#{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(journey_in)
    deduct(@journey.fare) if @journey.entry_station
    raise "Insufficient funds, please top up!" if balance < MINIMUM_BALANCE
    @journey = journey_in
  end

  def touch_out(station)
    @journey.end(station)
    deduct(@journey.fare)
    @history << { entry_station: @journey.entry_station, exit_station: @journey.exit_station}
    @journey = Journey.new
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
