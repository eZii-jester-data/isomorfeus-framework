if ENV['RACK_ENV'] != 'development'
  require_relative 'all_component_types_app'
  run AllComponentTypesApp.app
else
  require 'auto_reloader'
  AutoReloader.activate reloadable_paths: [__dir__], delay: 1
  run ->(env) do
    AutoReloader.reload! do |unloaded|
      # by default, AutoReloader only unloads constants when a watched file changes;
      # when it unloads code before calling this block, the value for unloaded will be true.
      ActiveSupport::Dependencies.clear if unloaded && defined?(ActiveSupport::Dependencies)
      require_relative 'all_component_types_app'
      AllComponentTypesApp.call env
    end
  end
end
