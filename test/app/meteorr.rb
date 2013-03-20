require 'sinatra'
require 'barista'

register Barista::Integration::Sinatra

register Jammit
::RAILS_ENV = "development" # this is needed to work around a Jammit limitation
Jammit.load_configuration("config/jammit.yml")


get '/' do
  'Hello world!'
end