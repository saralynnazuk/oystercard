require 'journeylog'

describe JourneyLog do
  let(:log) { described_class.new(journey) }

  let(:station_in) { double(:station) }
  let(:station_out) { double(:station) }
  let(:journey) { double :journey }

  describe '#start' do
    it 'starts a new journey with an entry station' do
      allow(journey).to receive(:new).with(station_in)
      allow(journey).to receive(:entry_station) { station_in }
      log.start(station_in)
      expect(log.journey_class.entry_station).to eq station_in
    end
  end


end
