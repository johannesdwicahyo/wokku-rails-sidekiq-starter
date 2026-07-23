# Wokku Rails + Sidekiq starter

Rails 8 with a Sidekiq worker process, PostgreSQL, and Redis, ready for
`git push` deploys on [Wokku](https://wokku.cloud). A single `web` process runs foreman, which supervises Rails and
Sidekiq inside one container (1 Wokku slot); `DATABASE_URL` and `REDIS_URL` come from the attached shared
addons. Visiting `/` enqueues a demo `PingJob` and shows queue stats.
