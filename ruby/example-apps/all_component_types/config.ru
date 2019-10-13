if ENV['RACK_ENV'] && ENV['RACK_ENV'] != 'development'
  require_relative 'all_component_types_app'
  Isomorfeus.zeitwerk.setup
  Isomorfeus.zeitwerk.eager_load

  run AllComponentTypesApp.app
else
  require_relative 'all_component_types_app'

  Isomorfeus.zeitwerk.enable_reloading
  Isomorfeus.zeitwerk.setup
  Isomorfeus.zeitwerk.eager_load

  run ->(env) do
    Isomorfeus.mutex.synchronize do
      Isomorfeus.zeitwerk.reload
      STDERR.puts "reloading!"
    end
    AllComponentTypesApp.call env
  end
end
