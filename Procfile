# Dokku reads this Procfile and spawns one container per process type.
# We keep it to a single 'web' entry that runs foreman, which in turn
# supervises Rails + Sidekiq inside this single container.
# Result: 1 Dokku container = 1 Wokku slot, both processes running.
# See: https://wokku.cloud/docs/scaling/bundled-processes
web: bundle exec foreman start -f Procfile.bundled
