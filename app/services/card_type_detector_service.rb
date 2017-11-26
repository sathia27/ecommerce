class CardTypeDetectorService
  def initialize(card_number)
    @card_number = card_number
  end

  def card_type
    if valid_amex?
      "AMEX"
    elsif valid_discover?
      "Discover"
    elsif valid_mastercard?
      "MasterCard"
    elsif valid_visa?
      "Visa"
    else
      "Unknown"
    end
  end

  private
  def card_number_length
    @card_number_length ||= @card_number.length
  end
  
  def valid_amex?
    card_number_length.eql?(15) and @card_number =~ /^(34|37)/
  end

  def valid_discover?
    card_number_length.eql?(16) and @card_number =~ /^6011/
  end

  def valid_mastercard?
    card_number_length.eql?(16) and @card_number =~ /^4/
  end

  def valid_visa?
    (card_number_length.eql?(13) or card_number_length.eql?(16)) and @card_number =~ /^4/
  end
end
