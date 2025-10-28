class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    mark_abandoned_carts
    remove_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    Cart.where('last_interaction_at <= ? AND abandoned = ?', 3.hours.ago, false)
        .update_all(abandoned: true)
    Rails.logger.info "Marked carts as abandoned"
  end

  def remove_old_abandoned_carts
    count = Cart.where('abandoned = ? AND last_interaction_at <= ?', true, 7.days.ago)
                .destroy_all
                .count
    Rails.logger.info "Removed #{count} old abandoned carts"
  end
end