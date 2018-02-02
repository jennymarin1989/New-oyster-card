require 'journey'

describe Journey do

  let(:entry_station) { double("entry station") }
  let(:exit_station) { double("exit station") }
  let(:oystercard) { double("Oystercard", balance: 20) }

  let(:journey) { described_class.new(entry_station) }

  describe "#initialize" do
    it "sets the entry station to the first argument" do
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe "#finish_journey" do
    it "sets the exit station to the passed argument" do
      allow(oystercard).to receive(:save_journey)
      journey.finish_journey(exit_station, oystercard)
      expect(journey.exit_station).to eq exit_station
    end

    it 'charges the card' do
      allow(oystercard).to receive(:touch_out)
      expect {oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-Oystercard::FARE)
    end
  end
end