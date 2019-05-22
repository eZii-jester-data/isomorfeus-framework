require 'bundler/setup'
if ENV['ALL_COMPONENT_TYPES_ENV'] && ENV['ALL_COMPONENT_TYPES_ENV'] == 'production'
  ENV['OWL_ENV'] = 'production'
  Bundler.require(:default, :production)
elsif ENV['ALL_COMPONENT_TYPES_ENV'] && ENV['ALL_COMPONENT_TYPES_ENV'] == 'test'
  ENV['OWL_ENV'] = 'production'
  Bundler.require(:default, :test)
else
  ENV['OWL_ENV'] = 'development'
  Bundler.require(:default, :development)
end

Opal.append_path(File.expand_path('isomorfeus'))
