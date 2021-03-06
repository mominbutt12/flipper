require 'test_helper'
require 'flipper/adapters/memory'
require 'flipper/adapters/redis_cache'

class DalliTest < MiniTest::Test
  prepend Flipper::Test::SharedAdapterTests

  def setup
    url = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
    @cache = Redis.new(url: url).tap(&:flushdb)
    memory_adapter = Flipper::Adapters::Memory.new
    @adapter = Flipper::Adapters::RedisCache.new(memory_adapter, @cache)
  end

  def teardown
    @cache.flushdb
  end
end
