require 'oystercard'

describe Oystercard do
  let(:station) { double(:station) }

  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
  end

    describe '#top_up' do
      it 'tops up the balance' do
        expect { subject.top_up 1 }.to change { subject.balance }.by 1
      end

      it 'raises an error if top up exceeds maximum balance' do
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        subject.top_up(maximum_balance)
        expect { subject.top_up 1 }.to raise_error "Maximum balance of £#{maximum_balance} exceeded"
      end

      it 'will not allow touch in if below minimum balance' do
        message = "Insufficient funds, please top up!"
        expect { subject.touch_in(station) }.to raise_error message
      end

    end

    describe '#in_journey' do
      it 'is initially not in a journey' do
        expect(subject).not_to be_in_journey
      end
    end

    describe '#touch_in' do
      before do
        subject.top_up(20)
      end

      it 'can touch in' do
        allow(station).to receive_messages( :name => "Aldgate" )
        subject.touch_in(station)
        expect(subject).to be_in_journey
      end

      it 'remembers its entry station' do
        allow(station).to receive_messages( :name => "Aldgate" )
        subject.touch_in(station)
        expect(subject.entry_station).to eq station.name
      end
    end

    describe '#touch_out' do
      before do
        subject.top_up(20)
      end

      it 'can touch out' do
        allow(station).to receive_messages( :name => "Aldgate" )
        subject.touch_in(station)
        subject.touch_out
        expect(subject).not_to be_in_journey
      end

      it 'deducts fare from the balance' do

        expect { subject.touch_out }.to change { subject.balance }.by -Oystercard::MINIMUM_FARE
      end
    end
end
