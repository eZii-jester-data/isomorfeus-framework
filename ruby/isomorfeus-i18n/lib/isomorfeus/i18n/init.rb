module Isomorfeus
  module I18n
    class Init
      if RUBY_ENGINE == 'opal'
        def self.init
          return if @initializing || initialized?
          @initializing = true
          if Isomorfeus.on_browser?
            root_element = `document.querySelector('div[data-iso-root]')`
            Isomorfeus.negotiated_locale = root_element.JS.getAttribute('data-iso-nloc')
          end
          Isomorfeus::Transport.promise_send_path('Isomorfeus::I18n::Handler::LocaleHandler', :init, Isomorfeus.negotiated_locale).then do |agent|
            if agent.processed
              agent.result
            else
              agent.processed = true
              if agent.response.key?(:error)
                `console.error(#{agent.response[:error].to_n})`
                raise agent.response[:error]
              end
              @initializing = false
              Isomorfeus.store.dispatch(type: 'I18N_LOAD', data: agent.response[:data])
            end
          end
        end

        def self.initialized?
          result = Redux.fetch_by_path(:i18n_state, :available_locales)
          result ? true : false
        end
      else
        def self.init
          FastGettext.add_text_domain(Isomorfeus.i18n_domain, path: Isomorfeus.locale_path, type: Isomorfeus.i18n_type)
          FastGettext.available_locales = Isomorfeus.available_locales
          FastGettext.text_domain = Isomorfeus.i18n_domain
          FastGettext.locale = Isomorfeus.locale
          Thread.current[:isomorfeus_i18n_initialized] = true
        end
      end
    end
  end
end
