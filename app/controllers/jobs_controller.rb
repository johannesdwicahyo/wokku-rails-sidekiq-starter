# Tiny proof-of-life endpoint for the bundled-sidekiq setup.
#   GET  /         → returns "wokku rails+sidekiq bundled · ok"
#   POST /jobs     → queues HelloWorldJob; check container logs for the message
#
# Both the GET and the POST are served by the rails process inside the
# bundled container; the POST's job runs in the sidekiq process inside
# the SAME container. Two processes, one container, one slot.
class JobsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def index
    render plain: "wokku rails+sidekiq bundled · ok\n"
  end

  def create
    HelloWorldJob.perform_later(params[:name] || "world")
    render plain: "queued — tail the container logs to see it run\n"
  end
end
