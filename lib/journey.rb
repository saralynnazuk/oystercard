class Journey

MINIMUM_FARE = 1
PENALTY = 6

attr_reader :entry_station, :exit_station

  def initialize(station = nil)
    @entry_station = station
  end

  def end(station)
    @exit_station = station
  end

  def complete?
    entry_station && exit_station
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY
  end

end
