require 'oystercard'
require 'journey'

describe Oystercard do

  let(:entry_station) { double 'entry_station' }
  let(:exit_station) { double 'exit_station' }
  let(:journey) { Journey.new(entry_station) }

  let(:oystercard) { described_class.new }
  let(:oyster_topped_up) do
    oystercard.top_up(Oystercard::MINIMUM_BALANCE)
    oystercard
  end
  let(:oyster_touched_in) do
    oyster_topped_up.touch_in(entry_station)
    oyster_topped_up
  end
  let(:oyster_touched_out) do
    oyster_touched_in.touch_out(exit_station)
    oyster_touched_in
  end

  it 'has initial balance of zero' do
    expect(oystercard.balance).to eq 0
  end

  it 'has empty journeys as default' do
    expect(oystercard.journeys).to be_empty
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end
    it 'tops up the oyster card' do
      expect { oystercard.top_up 1 }.to change { oystercard.balance }.by 1
    end

    context 'When maximum balance is exceeded' do
      it 'raises error ' do
        oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
        expect { oystercard.top_up 1 }.to raise_error 'Maximum balance exceeded'
      end
    end
  end

  describe '#touch_in' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    context 'When balance is greater than minimum balance' do
      before(:each) do
        oyster_touched_in
      end
      it 'starts a journey' do
        expect(oystercard.current_journey).not_to eq nil
      end

      it 'remember the entry station' do
        allow(oystercard).to receive(:entry_station).and_return(entry_station)
      end
    end

    context 'When balance is less than minimum balance' do
      subject(:oystercard) { described_class.new }
      it 'raises error' do
        expect { oystercard.touch_in(entry_station) }.to raise_error 'Not enough credit in your card'
      end
    end
  end

  describe '#touch_out' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'sets @current_journey to nil' do
      expect(oyster_touched_out.current_journey).to be_nil
    end

    it 'Add entry and exit station into journey array' do
      j = oyster_touched_in.current_journey
      expect(oyster_touched_out.journeys).to include(j)
    end
  end

  describe '#journey?' do
    it 'tells if the card is in journey' do
      expect(oyster_touched_in).to be_in_journey
    end
  end
end