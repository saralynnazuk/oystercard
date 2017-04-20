
require 'station'

describe Station do

  let(:station) { described_class.new("Aldgate", 2) }

  it 'knows its name' do
    expect(station.name).to eq("Aldgate")
  end

  it 'knows its zone' do
    expect(station.zone).to eq(2)
  end
end
