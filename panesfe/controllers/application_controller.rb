class ApplicationController < Sinatra::Application
  raise "No session secret found." unless ENV['SESSION_SECRET']
  use Rack::Session::Cookie, :key => 'panesfe.session',
                             :path => '/',
                             :secret => ENV['SESSION_SECRET']

  use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOGLE_OAUTH2_ID'], ENV['GOOGLE_OAUTH2_SECRET']
  end

end
