require 'json'

def json_response(data, code=200)
    [code, {'Content-Type' => 'application/json'}, [data.to_json]]
end

def aok
    json_response :a => 'ok'
end

def client_count count
    {clientCount: count}.to_json
end

def new_message msg
    {newMessage: msg}.to_json
end

def parse string
    begin
        JSON.parse string
    rescue
        string
    end
end