# app/services/card_type_detector.rb
require_relative '../../app/services/card_type_detector_service.rb'

describe CardTypeDetectorService do
  it "should return UNKNOWN for invalid card number" do
    card = CardTypeDetectorService.new("123343")
    expect(card.card_type).to eq "Unknown"
  end
  
  it "should return AMEX for valid amex card number" do
    card = CardTypeDetectorService.new("378282246310005")
    expect(card.card_type).to eq "AMEX"
  end

  it "should return Visa for valid visa card number" do
    card = CardTypeDetectorService.new("4111111111111")
    expect(card.card_type).to eq "Visa"
  end

  it "should return MasterCard for valid MasterCard card number" do
    card = CardTypeDetectorService.new("4111111111111111")
    expect(card.card_type).to eq "MasterCard"
  end

  it "should return Discover for valid Discover card number" do
    card = CardTypeDetectorService.new("6011111111111117")
    expect(card.card_type).to eq "Discover"
  end

end

