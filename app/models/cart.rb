class Card < ActiveRecord::Base
  has_many :order_items
  
  def add_items(items)
    @card.ordered_items += items
  end
end
