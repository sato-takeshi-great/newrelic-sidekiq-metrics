require 'bundler/setup'
require 'pry'
require 'sidekiq/cli'
require 'sidekiq/testing'
require 'newrelic-sidekiq-metrics'

Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.after(:each) do |example|
    NewrelicSidekiqMetrics.use(NewrelicSidekiqMetrics::DEFAULT_ENABLED_METRICS)
  end

  config.before(:each, type: :integration) do
    Sidekiq::Testing.server_middleware do |chain|
      chain.add NewrelicSidekiqMetrics::Middleware
    end
  end
end
