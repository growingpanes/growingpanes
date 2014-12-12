module Panesfe
  module I18nHelper
    def get_locale
      @env["HTTP_ACCEPT_LANGUAGE"][0,2]
    end

    def t(*args)
      I18n.t(*args)
    end
  end
end
