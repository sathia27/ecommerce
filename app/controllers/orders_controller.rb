class OrdersController < ApplicationController
  include UserCart
  def create
    @order = Order.new(order_params)
    @card.add_items(@order.ordered_items)
    if payment_call_made?
      if @order.process(order_params)
        destroy_cart
        flash[:success] = "You successfully ordered!"
        redirect_to confirmation_orders_path
      else
        flash[:error] = "There was a problem processing your order. Please try again."
        render :new
      end
    end
  end

  def order_params
    params.require(:order).permit!
  end

  private

  def billing_options
    billing_address = { name: "#{params[:billing_first_name]} #{params[:billing_last_name]}",
                        address1: params[:billing_address_line_1],
                        city: params[:billing_city], state: params[:billing_state],
                        country: 'US',zip: params[:billing_zip],
                        phone: params[:billing_phone] }

    options = { address: {}, billing_address: billing_address }
  end

  def gateway
    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
      login: ENV["AUTHORIZE_LOGIN"],
      password: ENV["AUTHORIZE_PASSWORD"]
    )

  end

  def payment_call_made?
    # Get the card type
    # Get credit card object from ActiveMerchant
    credit_card = get_credit_card
    # Check if card is valid
    if credit_card.valid?
      # Make the purchase through ActiveMerchant
      charge_amount = @order.calculate_charge_amount
      response = gateway.purchase(charge_amount, credit_card, billing_options)
      if !response.success?
        @order.errors.add(:error, "We couldn't process your credit card")
      end
    else
      @order.errors.add(:error, "Your credit card seems to be invalid")
      flash[:error] = "There was a problem processing your order. Please try again."
      render :new && return
    end
    return true
  end

  def get_card_type
    return CardTypeDetectorService.new(params[:card_info][:card_number]).card_type
  end

  def get_credit_card
    # Process credit card
    # Create a connection to ActiveMerchant
    ActiveMerchant::Billing::CreditCard.new(
      number: params[:card_info][:card_number],
      month: params[:card_info][:card_expiration_month],
      year: params[:card_info][:card_expiration_year],
      verification_value: params[:card_info][:cvv],
      first_name: params[:card_info][:card_first_name],
      last_name: params[:card_info][:card_last_name],
      type: get_card_type
    )
  end

end
