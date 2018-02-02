class Journey

  attr_reader :entry_station, :exit_station

  def initialize(entry_station)
    @entry_station = entry_station
  end

  def arrive=(exit_station)
    @exit_station = exit_station
  end
  def finish_journey(exit_station, oystercard)
    @exit_station = exit_station
    oystercard.save_journey
  end


end
