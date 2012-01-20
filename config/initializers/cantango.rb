CanTango.config do |config|
  config.debug.set :on
  config.engines.all :on
  # more configuration here...
  config.engine(:cache).set :off
end
