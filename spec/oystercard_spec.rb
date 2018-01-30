require 'oystercard'

describe Oystercard do

subject(:oystercard) { described_class.new }

  it 'has initial balance of zero' do
    expect(oystercard.balance).to eq (0)
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it "tops up the oyster card" do
      expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
    end
    it "raises error when maximum balance is exceeded" do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      expect{ oystercard.top_up 1 }.to raise_error "Maximum balance exceeded"
    end
  end

  it 'is initially not in a journey' do
    expect(subject).not_to be_in_journey
  end

  describe "#touch_in" do
    it "changes the card status to in_journey" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in
      expect(oystercard.card_status).to eq :in_journey
    end

    it "raises error when balance is less than minimun balance" do
      oystercard.top_up(0.5)
      expect{ oystercard.touch_in }.to raise_error "Not enough credit in your card"
    end

  end

  describe "#touch_out" do
    it "changes the card status to not_in_journey" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in
      oystercard.touch_out
      expect(oystercard.card_status).to eq :not_in_journey
    end
    it "charges the card" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in
      expect{ subject.touch_out }.to change{ subject.balance }.by(-Oystercard::FARE)
      end
    # touch_out is calling a private method deduct, but the test will work as
    # we are actually testing our deduct method implicitly whilst testing touch_out.
  end

  describe "#journey?" do
    it "tells if the card is in journey" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in
      expect(oystercard).to be_in_journey
    end
  end

end
