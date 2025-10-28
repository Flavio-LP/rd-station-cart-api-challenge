class RemoveAbandonedCartsJob
  include Sidekiq::Job

  def perform(*args)
    count = Cart.abandoned_carts.inactive_for(7.days).destroy_all.count
    Rails.logger.info "Removed #{count} old abandoned carts"
  end
end