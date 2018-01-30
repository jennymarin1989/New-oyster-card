class Oystercard

  attr_reader :balance
  attr_reader :card_status

  MAXIMUM_BALANCE = 90 #constant for limit of monay on card
  MINIMUM_BALANCE = 1
  FARE = 7

  def initialize
    @balance = 0
    @card_status = :not_in_journey
  end

  def top_up(amount)
    fail "Maximum balance exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in
    fail "Not enough credit in your card" if @balance < MINIMUM_BALANCE
    @card_status = :in_journey
  end

  def touch_out
    deduct(FARE)
    @card_status = :not_in_journey
  end

  def in_journey?
     @card_status == :in_journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
