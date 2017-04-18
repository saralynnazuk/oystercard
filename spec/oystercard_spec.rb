require 'oystercard'

describe Oystercard do
  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
  end

    describe '#top_up' do
      it 'tops up the balance' do
        expect { subject.top_up 1 }.to change { subject.balance }.by 1
      end

      it 'raises and error if top up exceeds maximum balance' do
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        subject.top_up(maximum_balance)
        expect { subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
      end
    end

    describe '#deduct' do
      it 'deducts fare from the balance' do
        subject.top_up(20)
        expect { subject.deduct 1 }.to change { subject.balance }.by -1
      end
    end

    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end

    describe '#touch_in' do
      it 'can touch in' do
        subject.touch_in
        expect(subject).to be_in_journey
      end
    end

    describe '#touch_out' do
      it 'can touch out' do
        subject.touch_in
        subject.touch_out
        expect(subject).not_to be_in_journey
      end
    end
end
