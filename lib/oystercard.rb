class Oystercard

  attr_reader :balance, :current_journey, :entry_station, :journeys

  MAXIMUM_BALANCE = 90 #constant for limit of money on card
  MINIMUM_BALANCE = 1
  FARE = 7

  def initialize
    @balance = 0
    @current_journey = nil
    @journeys = []
  end

  def top_up(amount)
    fail "Maximum balance exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(name_station)
    fail "Not enough credit in your card" if @balance < MINIMUM_BALANCE
    @current_journey = Journey.new(name_station)
  end

  def touch_out(exit_station)
    deduct(FARE)
    @current_journey.finish_journey(exit_station, self)
    @current_journey = nil
  end

  def in_journey?
     !!@current_journey
  end

  def save_journey
    @journeys << @current_journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end