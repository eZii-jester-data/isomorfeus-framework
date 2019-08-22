require 'opal-activesupport'
require 'isomorfeus-transport'

if RUBY_ENGINE == 'opal'
  require 'isomorfeus/data/core_ext/hash/deep_merge'
  require 'isomorfeus/i18n/config'
  require 'isomorfeus/i18n/reducer'
  Isomorfeus::I18n::Reducer.add_reducer_to_store
  require 'lucid_translation/mixin'
  require 'isomorfeus/i18n/init'
  Isomorfeus.add_transport_init_class_name('Isomorfeus::I18n::Init')
else
  require 'active_support'
  require 'oj'
  require 'fast_gettext'
  require 'http_accept_language/parser'
  require 'http_accept_language/middleware'
  require 'isomorfeus/promise'
  require 'isomorfeus-data'
  require 'isomorfeus/i18n/config'
  require 'isomorfeus/i18n/init'
  require 'lucid_translation/mixin'
  require 'isomorfeus/i18n/handler/locale_handler'

  Isomorfeus.add_middleware(HttpAcceptLanguage::Middleware)

  Opal.append_path(__dir__.untaint) unless Opal.paths.include?(__dir__.untaint)

  Isomorfeus.locale_path = File.expand_path(File.join('isomorfeus', 'locales'))

  # identify available locales
  locales = []

  Dir.glob("#{Isomorfeus.locale_path}/**/*.mo").each do |file|
    locales << File.basename(file, '.mo')
  end
  Isomorfeus.i18n_type = :mo unless locales.empty?

  unless Isomorfeus.i18n_type
    locales = []
    Dir.glob("#{Isomorfeus.locale_path}/**/*.po").each do |file|
      locales << File.basename(file, '.po')
    end
    Isomorfeus.i18n_type = :po unless locales.empty?
  end

  unless Isomorfeus.i18n_type
    locales = []
    Dir.glob("#{Isomorfeus.locale_path}/**/*.yaml").each do |file|
      locales << File.basename(file, '.yaml')
    end
    Dir.glob("#{Isomorfeus.locale_path}/**/*.yml").each do |file|
      locales << File.basename(file, '.yml')
    end
    Isomorfeus.i18n_type = :yaml unless locales.empty?
  end

  Isomorfeus.available_locales = locales
  Isomorfeus.available_locales = ['en'] if Isomorfeus.available_locales.empty?

  if Isomorfeus.available_locales.include?('en')
    Isomorfeus.locale = 'en'
  else
    Isomorfeus.locale = Isomorfeus.available_locales.first
  end

  Isomorfeus.i18n_domain = 'app'

  Isomorfeus::I18n::Init.init
end