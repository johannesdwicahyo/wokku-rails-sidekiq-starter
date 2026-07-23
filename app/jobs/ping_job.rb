class PingJob < ApplicationJob
  queue_as :default

  def perform(visited_at)
    Rails.logger.info("PingJob ran (enqueued at #{visited_at})")
  end
end
