source "https://rubygems.org"

ruby "3.4.3"

# Rails core
gem "rails", "~> 8.1.3"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"

# Sidekiq + Redis — background job processing
gem "sidekiq", "~> 7.3"
gem "redis", "~> 5.3"

# foreman — supervises rails web + sidekiq inside ONE container.
# Without foreman, Dokku would spawn a container per Procfile entry,
# consuming 2 slots. With foreman bundled into a single 'web' Procfile
# entry, Dokku sees one container = one slot.
# See https://wokku.cloud/docs/scaling/bundled-processes
gem "foreman", "~> 0.88"

gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
end
