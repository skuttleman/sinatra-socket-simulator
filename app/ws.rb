class WSHandler < Sinatra::Base
    set :state, State.create

    get '/simulator' do
        pass unless request.websocket?
        request.websocket do |ws|
            ws.onopen { open_ws_sim ws, settings.state }
            ws.onclose { close_ws_sim ws, settings.state }
        end
    end

    get '*' do
        pass unless request.websocket?
        request.websocket do |ws|
            ws.onopen { open_ws ws, settings.state }
            ws.onclose { close_ws ws, settings.state }
            ws.onmessage { |msg| on_message settings.state, msg }
        end
    end
end

def open_ws ws, state
    state.sockets << ws
    state.mes.each do |me|
        me.send client_count state.sockets.size
    end
end

def open_ws_sim ws, state
    state.mes << ws
    ws.send client_count state.sockets.size
end

def close_ws ws, state
    state.sockets.delete ws
    state.mes.each do |me|
        me.send client_count state.sockets.size
    end
end

def close_ws_sim ws, state
    state.mes.delete ws
end

def on_message state, message
    state.socket_messages << parse(message)
    state.mes.each do |me|
        me.send new_message message
    end
end