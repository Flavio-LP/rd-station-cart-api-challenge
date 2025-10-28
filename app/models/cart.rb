class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado

  scope :inactive_for, ->(time) { where('last_interaction_at <= ?', time.ago) }
  scope :not_abandoned, -> { where(abandoned: false) }
  scope :abandoned_carts, -> { where(abandoned: true) }

  def mark_as_abandoned
    update(abandoned: true)
  end

  def remove_if_abandoned
    destroy if abandoned? && last_interaction_at <= 7.days.ago
  end
  
  def abandoned?
    abandoned == true
  end

  def calculate_total
    cart_items.joins(:product).sum('products.price * cart_items.quantity')
  end

  def update_total!
    update!(total_price: calculate_total)
  end
end