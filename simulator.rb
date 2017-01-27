require 'sinatra'
require 'sinatra-websocket'

require './app/state'
require './app/api'
require './app/ws'
require './helpers/json'

class SocketSimulator < Sinatra::Base
    set :public_folder, 'public'

    use APIHandler
    use WSHandler

    get '/' do
        send_file File.join(settings.public_folder, 'index.html')
    end

    get '*' do
        json_response({ unknown: 'resource' }, 404)
    end
end
