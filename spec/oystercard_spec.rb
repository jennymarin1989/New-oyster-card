require 'oystercard'

describe Oystercard do

subject(:oystercard) { described_class.new }
let(:station) {double :station}

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
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it "changes the card status to in_journey" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in(station)
      expect(oystercard.card_status).to eq :in_journey
    end

    it "raises error when balance is less than minimun balance" do
      oystercard.top_up(0.5)
      expect{ oystercard.touch_in (station)}.to raise_error "Not enough credit in your card"
    end

    it "remember the entry station" do
    allow(oystercard).to receive(:station).and_return(station)
    end
  end

  describe "#touch_out" do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it "changes the card status to not_in_journey" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in(station)
      oystercard.touch_out(station)
      expect(oystercard.card_status).to eq :not_in_journey
    end
    it "charges the card" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in(station)
      expect{ subject.touch_out(station) }.to change{ subject.balance }.by(-Oystercard::FARE)
      end
  end

  describe "#journey?" do
    it "tells if the card is in journey" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in(station)
      expect(oystercard).to be_in_journey
    end
  end

end
