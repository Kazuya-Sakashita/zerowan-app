# config/initializers/redis.rb

require 'redis'

REDIS_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join('config', 'redis.yml'))).result)[Rails.env].symbolize_keys

$redis = Redis.new(host: REDIS_CONFIG[:host], port: REDIS_CONFIG[:port])
