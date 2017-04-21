require 'journey'

describe Journey do
  let(:journey) { described_class.new(station_in) }

  let(:station_in) { double(:station) }
  let(:station_out) { double(:station) }

  it "starts a journey" do
    expect(journey.entry_station).to eq station_in
  end

  describe '#end' do
    it 'finishes a journey' do
      journey.end(station_out)
      expect(journey.exit_station).to eq station_out
    end
  end

  describe '#complete?' do
    context "with no exit station" do
      it "returns false" do
        expect(journey).to_not be_complete
      end
    end

    context "with an exit station" do
      it "returns true" do
        journey.end(station_out)
        expect(journey).to be_complete
      end
    end
  end

  describe '#fare' do
    context "when journey complete" do
      it "returns minimum fare" do
        journey.end(station_out)
        expect(journey.fare).to eq described_class::MINIMUM_FARE
      end
    end

    context "when journey incomplete" do
      it "return penalty fare" do
        expect(journey.fare).to eq described_class::PENALTY
      end
    end
  end

end
