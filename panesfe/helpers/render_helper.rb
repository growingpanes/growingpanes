module Panesfe
  module RenderHelper

    # Convenience method to render the matching named template
    # in the controller's view directory. The name is to not
    # conflict with sinatra's `render`
    def frender *args
      template_name = args.shift.to_s + '.html'
      template_dir = self.class.name.demodulize.sub(/Controller$/,'').downcase
      erb File.join(template_dir, template_name).to_sym, *args
    end

  end
end
