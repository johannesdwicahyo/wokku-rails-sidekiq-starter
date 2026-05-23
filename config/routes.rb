Rails.application.routes.draw do
  # Dokku / Wokku health check.
  get "up" => "rails/health#show", as: :rails_health_check

  # Proof-of-life: a rails endpoint that queues a sidekiq job.
  # GET  /        → 200 ok
  # POST /jobs    → queues HelloWorldJob (logged by the bundled sidekiq)
  root  "jobs#index"
  post  "/jobs", to: "jobs#create"
end
