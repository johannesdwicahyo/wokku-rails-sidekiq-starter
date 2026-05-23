# wokku-rails-sidekiq-starter

Production-ready Rails 8 with Sidekiq, supervised by `foreman` inside a **single Dokku container** so it consumes 1 Wokku slot instead of 2.

## What this demonstrates

Most Rails apps want background jobs (mailers, image processing, webhook delivery). The textbook setup runs them as a separate Dokku process:

```procfile
# 2 containers = 2 slots on Wokku
web:    bundle exec rails server
worker: bundle exec sidekiq
```

This starter instead **bundles both processes into one container**:

```procfile
# 1 container = 1 slot
web: bundle exec foreman start -f Procfile.bundled
```

`foreman` supervises Rails web + Sidekiq side-by-side inside the same container. Dokku still sees one process type. Wokku still charges one slot. You still get a working background job queue.

See [the bundling guide](https://wokku.cloud/docs/scaling/bundled-processes) for when this pattern fits — and when you want to go back to split containers (production-scale, uneven scaling, crash isolation).

## Deploy to Wokku

[![Deploy to Wokku](https://wokku.cloud/deploy-button.svg)](https://wokku.cloud/templates/rails-sidekiq)

Click → pick a tier (**Solo** is enough for hobby; **Pro** for production) → live at `https://<your-app>.wokku.cloud` in ~90 seconds. The Redis addon is attached automatically per `app.json`.

After deploy, verify both processes are running:

```bash
# Hit the rails endpoint
curl https://<your-app>.wokku.cloud/

# Queue a sidekiq job
curl -X POST https://<your-app>.wokku.cloud/jobs?name=wokku

# Tail the container logs — you should see Rails logs + the
# "[HelloWorldJob] Hello, wokku!" line from the bundled Sidekiq.
wokku logs <your-app> -t
```

## Local development

```bash
bundle install
bin/rails db:prepare

# Start both processes locally (same Procfile.bundled production uses)
bundle exec foreman start -f Procfile.bundled

# Or run them separately if you prefer
bin/rails server
bundle exec sidekiq -C config/sidekiq.yml
```

Requires a running Redis on `localhost:6379` for local dev. Easiest:

```bash
docker run -d -p 6379:6379 redis:7
```

## What's inside

- **Rails 8** minimal (no Action Cable, Mailer, JBuilder)
- **Sidekiq 7** for background jobs, talking to Redis via `REDIS_URL`
- **foreman** as the in-container process supervisor
- **SQLite** for app data (file-based, no Postgres needed — swap to `pg` + a Postgres addon when you grow)
- **`HelloWorldJob`** demo job + **`JobsController`** to enqueue it

Runtime: Ruby 3.4.3 (pinned in `Gemfile`).

## Memory sizing

`foreman` runs both processes in the same container. Total memory needed = peak Rails RSS + peak Sidekiq RSS + ~20% headroom.

| Workload | Tier |
|---|---|
| Hobby app, low-volume jobs | **Small** (Rp 75k/mo on Solo) |
| Production Rails (~50-200 req/s) + light jobs | **Medium** (Rp 225k/mo on Pro) |
| Heavy Sidekiq jobs (image processing, PDF generation) | Split — give Sidekiq its own slot. See the bundling guide. |

## Splitting back into separate containers

If you outgrow the bundled setup (worker memory spikes, want independent scaling), edit `Procfile` to:

```procfile
web:    bundle exec rails server -p $PORT
sidekiq: bundle exec sidekiq -C config/sidekiq.yml
```

…and remove `Procfile.bundled`. On next deploy Dokku will spawn two containers; Wokku will count them as two slots.
