module Panesfe
  module Controllers
    class RootController < ApplicationController
      get '/?' do
        redirect to(logged_in_home) if current_user
        frender :index
      end
    end
  end

  class App
    use Controllers::RootController
  end
end
