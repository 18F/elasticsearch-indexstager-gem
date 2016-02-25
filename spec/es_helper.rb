require 'elasticsearch/extensions/test/cluster'
require 'elasticsearch/extensions/test/startup_shutdown'

class ESHelper
  def self.setup
    logger = ::Logger.new(STDERR)
    logger.formatter = lambda { |s, d, p, m| "#{m.ansi(:faint, :cyan)}\n" }
    tracer = ::Logger.new(STDERR)
    tracer.formatter = lambda { |s, d, p, m| "#{m.gsub(/^.*$/) { |n| '   ' + n }.ansi(:faint)}\n" }
    es_host = "localhost:#{(ENV['TEST_CLUSTER_PORT'] || 9250)}"
    @@client = Elasticsearch::Client.new host: es_host, tracer: (ENV['QUIET'] ? nil : tracer)
  end

  def self.startup
    unless ENV["ES_SKIP"] || Elasticsearch::Extensions::Test::Cluster.running?
      Elasticsearch::Extensions::Test::Cluster.start(nodes: 1)
    end
  end

  def self.shutdown
    Elasticsearch::Extensions::Test::Cluster.stop if Elasticsearch::Extensions::Test::Cluster.running?
  end

  def self.client
    @@client
  end

  def self.refresh(index_name)
    client.indices.refresh index: index_name
  end
end
