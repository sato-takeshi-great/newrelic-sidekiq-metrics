RSpec.describe NewrelicSidekiqMetrics do
  describe '.available_metrics' do
    it do
      expect(described_class.available_metrics).to match_array(%i[processed failed scheduled_size retry_size dead_size enqueued processes_size workers_size])
    end
  end

  describe '.enabled_metrics' do
    it do
      expect(described_class.enabled_metrics).to match_array(%i[enqueued retry_size])

      described_class.set_metrics(:processed, :enqueued, :foo)

      expect(described_class.enabled_metrics).to match_array(%i[processed enqueued])
    end
  end

  describe '.add_client_middleware' do
    it do
      expect(Sidekiq.client_middleware.entries.size).to eq(1)
      expect(Sidekiq.client_middleware.entries[0].klass).to eq(NewrelicSidekiqMetrics::ClientMiddleware)
    end
  end

  describe '.add_server_middleware' do
    it do
      expect(Sidekiq.server_middleware.entries.size).to eq(1)
      expect(Sidekiq.server_middleware.entries[0].klass).to eq(NewrelicSidekiqMetrics::ServerMiddleware)
    end
  end
end
