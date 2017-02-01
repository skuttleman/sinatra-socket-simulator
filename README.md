# Sinatra Socket Simulator

A simple Sinatra app that lets you connect with sockets and simulate actions from a client. I built this for
automated testing of a client socket app. On first iteration, it only accepts and serves up JSON data via
http calls and websocket messages.

## API

### GET `/health`

Produces a 200 JSON response if the simulator is up and running.

### GET `/messages`

Produces a list of websocket messages received by the simulator. Websocket messages need to be valid JSON.

### POST `/message`

Takes a valid JSON body and sends it to all open websocket connections.

### DELETE `/messages`

Clears/resets the websocket messages.

## Getting Started

Run the simulator.

```bash
$ git clone https://github.com/skuttleman/sinatra-socket-simulator.git
$ cd sinatra-socket-simulator
$ bundle install
$ rackup -p 4444 socket.ru
```

## User Interface

Visit `http://localhost:4444` in a browser that supports websockets to monitor websocket messages received and
to broadcast JSON data to all active websocket clients.

## Connect an app to the simulator

In your app's javascript, the following will connect to the simulator:

```js
var socket = new WebSocket('ws://localhost:4444/almost/any/path');

socket.onmessage = function(message) {
    console.log('received websocket message', JSON.parse(message.data));
};

socket.onopen = function() {
    socket.send('{"some":"json","message":["goes","here"]}');
};
```