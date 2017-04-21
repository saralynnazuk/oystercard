require 'oystercard'
require 'journey'

describe Oystercard do

  let(:card) { described_class.new }

  let(:station_in) { double(:station) }
  let(:station_out) { double(:station) }
  let(:journey) { double :journey, station: station_in }

  it 'has a balance of zero' do
    expect(card.balance).to eq(0)
  end

  it 'has an empty journey list upon instantiation' do
    expect(card.history).to be_empty
  end

    describe '#top_up' do
      it 'tops up the balance' do
        expect { card.top_up 1 }.to change { card.balance }.by 1
      end

      it 'raises an error if top up exceeds maximum balance' do
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        card.top_up(maximum_balance)
        expect { card.top_up 1 }.to raise_error "Maximum balance of £#{maximum_balance} exceeded"
      end

      it 'will not allow touch in if below minimum balance' do
        message = "Insufficient funds, please top up!"
        expect { card.touch_in(station_in) }.to raise_error message
      end

    end

    describe '#touch_in' do
      before do
        card.top_up(20)
      end

      it 'can touch in' do
        # allow(station_in).to receive_messages( :name => "Aldgate" )
        allow(journey).to receive(:entry_station) { station_in }
        card.touch_in(journey)
        expect(card.journey.entry_station).to eq station_in
      end
    end

    describe '#touch_out' do
      before do
        card.top_up(20)
      end

      it 'deducts minimum fare from the balance when journey completed' do
        allow(journey).to receive(:end).with(station_out)
        allow(journey).to receive(:fare) { Journey::MINIMUM_FARE }
        allow(journey).to receive(:entry_station)
        allow(journey).to receive(:exit_station)
        card.touch_in(journey)
        expect { card.touch_out(station_out) }.to change { card.balance }.by -Journey::MINIMUM_FARE
      end

    end

  describe 'journey' do
    before do
      card.top_up(20)
    end

    it 'stores a journey - entry and exit' do
      allow(journey).to receive(:end).with(station_out)
      allow(journey).to receive(:fare) { Journey::MINIMUM_FARE }
      allow(journey).to receive(:entry_station) { station_in }
      allow(journey).to receive(:exit_station) { station_out }
      card.touch_in(journey)
      card.touch_out(station_out)
      one_journey = { :entry_station => station_in , :exit_station => station_out  }
      expect(card.history).to include one_journey
    end
  end

end
