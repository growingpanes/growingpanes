module Panesfe
  module Controllers
    class PresentationsController < ApplicationController
      get '/presentations/?' do
        presentations = current_user.presentations
        frender :index, :locals => {presentations: presentations}
      end



    end
  end

  class App
    use Controllers::PresentationsController
  end
end
