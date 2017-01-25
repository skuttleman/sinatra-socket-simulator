# Sinatra Socket Simulator

A simple Sinatra app that lets you connect with sockets and simulate actions from a client. I built this for
automated testing of a client socket app.

## Using It

Get started with.

```bash
$ bundle install
$ rackup -p 4444 socket.ru
```

Connect with a websocket client and send json messages.

In your Chrome Console:

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

Send a post request to broadcast a socket to all clients

```bash
$ curl -X 'POST' http://localhost:4444/messages --data-raw '{"broadcast":"message"}'
{"a":"ok"}
```

You should see the MessageEvent logged in Chrome's console (for every tab you have connected via socket).