require 'station'

describe Station do

  example_zone = 2
  name = "Aldgate"
  subject(:station) {described_class.new(name, example_zone)}
  it "Initialize method receives zone argument" do
    expect(station.zone).to eq example_zone
  end
  it " Initialize method receives name argument " do
    expect(station.name).to eq name
  end
end