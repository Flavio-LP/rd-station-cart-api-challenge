class Cart < ApplicationRecord
  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def mark_as_abandoned
    update(abandoned: true)
  end

  def remove_if_abandoned
    destroy if abandoned? && last_interaction_at <= 7.days.ago
  end

  def abandoned?
    abandoned == true
  end
end