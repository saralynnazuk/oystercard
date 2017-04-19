require 'oystercard'

describe Oystercard do

  let(:card) { described_class.new }

  let(:station_in) { double(:station) }
  let(:station_out) { double(:station) }

  it 'has a balance of zero' do
    expect(card.balance).to eq(0)
  end

  it 'has an empty journey list upon instantiation' do
    expect(card.journey).to be_empty
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

    describe '#in_journey' do
      it 'is initially not in a journey' do
        expect(card).not_to be_in_journey
      end
    end

    describe '#touch_in' do
      before do
        card.top_up(20)
      end

      it 'can touch in' do
        allow(station_in).to receive_messages( :name => "Aldgate" )
        card.touch_in(station_in)
        expect(card).to be_in_journey
      end

      it 'remembers its entry station' do
        allow(station_in).to receive_messages( :name => "Aldgate" )
        card.touch_in(station_in)
        expect(card.entry_station).to eq station_in.name
      end
    end

    describe '#touch_out' do
      before do
        card.top_up(20)
      end

      it 'can touch out' do
        allow(station_in).to receive_messages( :name => "Aldgate" )
        allow(station_out).to receive_messages( :name => "Liverpool Street" )
        card.touch_in(station_in)
        card.touch_out(station_out)
        expect(card).not_to be_in_journey
      end

      it 'deducts fare from the balance' do
        allow(station_out).to receive_messages( :name => "Liverpool Street" )
        expect { card.touch_out(station_out) }.to change { card.balance }.by -Oystercard::MINIMUM_FARE
      end

      it 'remembers exit station' do
        allow(station_out).to receive_messages( :name => "Liverpool Street")
        card.touch_out(station_out)
        expect(card.exit_station).to eq station_out.name
      end

    end
  describe 'journey' do
    before do
      card.top_up(20)
    end

    it 'stores a journey - entry and exit' do
      allow(station_in).to receive_messages( :name => "Aldgate" )
      allow(station_out).to receive_messages( :name => "Liverpool Street" )
      card.touch_in(station_in)
      card.touch_out(station_out)
      any_name_hash = { :entry_station => station_in.name, :exit_station => station_out.name }
      expect(card.journey).to eq any_name_hash
    end
  end

end
