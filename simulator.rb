require 'sinatra'
require 'sinatra-websocket'

require './helpers/json'

class SocketSimulator < Sinatra::Base
    set :socket_messages, []
    set :sockets, []

    get '/health' do
        aok
    end

    get '/messages' do
        json_response :messages => settings.socket_messages
    end

    post '/messages' do
        msg = request.body.read
        settings.sockets.each do |socket|
            socket.send msg
        end
        aok
    end

    delete '/messages' do
        settings.socket_messages.clear
        aok
    end

    get '*' do
        pass unless request.websocket?
        request.websocket do |ws|
            ws.onopen do
                settings.sockets << ws
            end

            ws.onmessage do |msg|
                settings.socket_messages << JSON.parse(msg)
            end

            ws.onclose do
                settings.sockets.delete ws
            end
        end
    end

    get '*' do
        json_response({ :unknown => 'resource' }, 404)
    end
end
