# Trivial proof-of-life job. Hitting POST /jobs queues it; the
# bundled sidekiq process picks it up within milliseconds and logs
# the message. Use Sidekiq's web UI at /sidekiq (mount it in
# routes.rb when you're ready) to watch the queue.
class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(name = "world")
    Rails.logger.info "[HelloWorldJob] Hello, #{name}!"
  end
end
