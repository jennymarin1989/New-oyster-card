require 'oystercard'

describe Oystercard do

subject(:oystercard) { described_class.new }
let(:entry_station) {double "entry_station"}
let(:exit_station) {double "exit_station"}
let(:journey) {{entry_station: entry_station, exit_station: exit_station}}

  it 'has initial balance of zero' do
    expect(oystercard.balance).to eq (0)
  end
  it 'has empty journeys as default' do
    expect(oystercard.journeys).to be_empty
  end

  describe '#top_up' do
      it { is_expected.to respond_to(:top_up).with(1).argument }
      it 'is initially not in a journey' do
        expect(subject).not_to be_in_journey
      end
      it "tops up the oyster card" do
      expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
    end

    context "When maximum balance is exceeded" do
      it "raises error " do
        oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
        expect{ oystercard.top_up 1 }.to raise_error "Maximum balance exceeded"
      end
    end
  end


  describe "#touch_in" do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    context "When balance is greater than minimum balance" do
      before(:each) do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE)
        oystercard.touch_in(entry_station)
      end
      it "changes the card status to in_journey" do
        expect(oystercard.card_status).to eq :in_journey
      end

      it "remember the entry station" do
      allow(oystercard).to receive(:entry_station).and_return(entry_station)
      end
    end

    context "When balance is less than minimum balance" do
      subject(:oystercard) {described_class.new}
      it "raises error" do
        expect{ oystercard.touch_in(entry_station)}.to raise_error "Not enough credit in your card"
      end
    end
  end

  describe "#touch_out" do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    before(:each) do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in(entry_station)
    end
    it "changes the card status to not_in_journey" do
      oystercard.touch_out(exit_station)
      expect(oystercard.card_status).to eq :not_in_journey
    end
    it "charges the card" do
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::FARE)
    end
    it "deletes the entry station" do
      oystercard.touch_out(exit_station)
      expect(oystercard.entry_station).to eq nil
    end

    it "Add entry and exit station into journey array" do
      oystercard.touch_out(exit_station)
      expect(oystercard.journeys).to include(journey)
    end
  end

  describe "#journey?" do
    it "tells if the card is in journey" do
      oystercard.top_up(Oystercard::MINIMUM_BALANCE)
      oystercard.touch_in(entry_station)
      expect(oystercard).to be_in_journey
    end
  end

end
