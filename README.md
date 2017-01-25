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

Connect with a websocket client and send json messages.

For example, from Chrome's Console:

```js
var socket = new WebSocket('ws://localhost:4444')
socket.onmessage = console.log
socket.send('{"some":"message"}')
socket.send('{"some":"other message"}')
```

Now hit the api with an http client of your choosing:

```bash
$ curl http://localhost:4444/messages
{"messages":[{"some":"message"},{"some":"other message"}]}
$ curl -X 'DELETE' http://localhost:4444/messages
{"a":"ok"}
$ curl http://localhost:4444/messages
{"messages":[]}
```

Send a post request to broadcast a message to all websocket connections.

```bash
$ curl -X 'POST' http://localhost:4444/messages --data-raw '{"broadcast":"message"}'
{"a":"ok"}
```

You should see the MessageEvent logged in Chrome's console (for every tab you have connected via websocket).
