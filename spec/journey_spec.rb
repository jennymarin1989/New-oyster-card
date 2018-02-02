require 'journey'

describe Journey do

  let(:entry_station) { double("entry station") }
  let(:exit_station) { double("exit station") }
  let(:oystercard) {double("Oystercard")}

  let(:journey) { described_class.new(entry_station) }

  describe "#intialize" do
    it "sets the entry station to the first argument" do
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe "#arrive" do
    it "sets the exit station to the passed argument" do
      allow(oystercard).to receive(:save_journey)
      journey.finish_journey(exit_station, oystercard)
      expect(journey.exit_station).to eq exit_station
    end
  end


end
