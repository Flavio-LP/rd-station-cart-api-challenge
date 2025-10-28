class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    count = Cart.not_abandoned.inactive_for(3.hours).update_all(abandoned: true)
    Rails.logger.info "Marked #{count} carts as abandoned"
  end
end