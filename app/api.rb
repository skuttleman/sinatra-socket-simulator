class APIHandler < Sinatra::Base
    set :state, State.create

    get '/messages' do
        json_response :messages => settings.state.socket_messages
    end

    post '/messages' do
        msg = request.body.read
        settings.state.sockets.each do |socket|
            socket.send msg
        end
        aok
    end

    delete '/messages' do
        settings.state.socket_messages.clear
        aok
    end
end