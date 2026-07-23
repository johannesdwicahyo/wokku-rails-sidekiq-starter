# Wokku spawns one container per process type. We keep a single 'web'
# entry that runs foreman, which supervises Rails + Sidekiq inside this
# one container. Result: 1 container = 1 Wokku slot, both processes
# running. See: https://wokku.cloud/docs/scaling/bundled-processes
web: bundle exec foreman start -f Procfile.bundled
