class Order < ActiveRecord::Base
  def calculate_charge_amount
    calculate_total_order_amount
    return (self.total.to_f*100).to_i
  end

  def process(options)
    self.order_status = "processed"
    if self.save
      OrderMailer.order_confirmation(options[:billing_email], id).deliver
      return true
    else
      return false
    end
  end

  private 

  def calculate_total_order_amount
    case shipping_method
    when 'ground' 
      self.total = taxed_total.round(2)
    when 'two-day'
      self.total = taxed_total + 15.75.round(2)
    when 'overnight'
      self.total = taxed_total + 25.round(2)
    end
  end
end
