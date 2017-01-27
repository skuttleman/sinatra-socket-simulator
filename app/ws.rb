class WSHandler < Sinatra::Base
    set :state, State.create

    get '/simulator' do
        pass unless request.websocket?
        request.websocket do |ws|
            ws.onopen do
                settings.state.mes << ws
                ws.send client_count settings.state.sockets.size
            end

            ws.onclose do
                settings.state.mes.delete ws
            end
        end
    end

    get '*' do
        pass unless request.websocket?
        request.websocket do |ws|
            ws.onopen do
                settings.state.sockets << ws
                settings.state.mes.each do |me|
                    me.send client_count settings.state.sockets.size
                end
            end

            ws.onmessage do |msg|
                settings.state.socket_messages << parse(msg)
                settings.state.mes.each do |me|
                    me.send new_message msg
                end
            end

            ws.onclose do
                settings.state.sockets.delete ws
                settings.state.mes.each do |me|
                    me.send client_count settings.state.sockets.size
                end
            end
        end
    end
end