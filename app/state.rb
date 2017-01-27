class State
    def State.create
        @@state ||= State.new
        @@state
    end

    def initialize
        @socket_messages = []
        @sockets = []
        @mes = []
    end

    def socket_messages
        @socket_messages
    end

    def sockets
        @sockets
    end

    def mes
        @mes
    end
end
