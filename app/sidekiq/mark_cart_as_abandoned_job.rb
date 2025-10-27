class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    # TODO Impletemente um Job para gerenciar, marcar como abandonado. E remover carrinhos sem interação. 
    mark_abandoned_carts
    remove_old_abandoned_carts
  end

  def mark_abandoned_carts
    Cart.where('last_interaction_at <= ? AND (abandoned = ? OR abandoned IS NULL)', 3.hours.ago, false)
        .update_all(abandoned: true)
  end

  def remove_old_abandoned_carts
    Cart.where('abandoned = ? AND last_interaction_at <= ?', true, 7.days.ago)
        .destroy_all
  end
end
