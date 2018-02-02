require 'journey'

describe Journey do

  let(:entry_station) { double("entry station") }
  let(:exit_station) { double("exit station") }

  subject(:journey) { described_class.new(entry_station) }

  describe "#intialize" do
    it "sets the entry station to the first argument" do
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe "#arrive" do
    it "sets the exit station to the passed argument" do
      expect(journey.arrive=(exit_station)).to eq exit_station
    end
  end


end
