class Oystercard

  attr_reader :balance, :card_status, :entry_station, :journeys

  MAXIMUM_BALANCE = 90 #constant for limit of monay on card
  MINIMUM_BALANCE = 1
  FARE = 7

  def initialize
    @balance = 0
    @card_status = :not_in_journey
    @journeys = []
    @entry_station = nil
  end

  def top_up(amount)
    fail "Maximum balance exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(name_station)
    fail "Not enough credit in your card" if @balance < MINIMUM_BALANCE
    @card_status = :in_journey
    @entry_station = name_station
  end

  def touch_out(name_station)
    deduct(FARE)
    @card_status = :not_in_journey
    @journeys << {entry_station: @entry_station, exit_station: name_station}
    @entry_station = nil
    name_station

  end

  def in_journey?
     @card_status == :in_journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
