require 'station'

describe Station do
let(:station) { described_class.new("Aldgate", 2) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:zone) }
end
