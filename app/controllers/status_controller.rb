require "sidekiq/api"

class StatusController < ApplicationController
  def show
    PingJob.perform_later(Time.current.utc.iso8601)
    stats = Sidekiq::Stats.new
    render json: {
      status: "ok", app: "wokku-rails-sidekiq-starter",
      jobs: { processed: stats.processed, enqueued: stats.enqueued },
      note: "a PingJob was enqueued by this request"
    }
  end
end
