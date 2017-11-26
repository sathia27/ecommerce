module UserCart
  extend ActiveSupport::Concern
  included do
    before_action :get_cart
  end

  def get_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
  end

  def destroy_cart
    Cart.destroy(session[:cart_id])
  end
end
