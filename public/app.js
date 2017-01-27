var socket = new WebSocket('ws://' + window.location.host + '/simulator');

socket.onmessage = function (message) {
    var data = parse(message.data);

    if (data.clientCount !== undefined) {
        document.getElementById('clientCount').innerHTML = data.clientCount;
    } else if (data.newMessage !== undefined) {
        appendLi(message.data);
    }
};

getMessages();

function getMessages() {
    ajax('get', '/messages').then(function(response) {
        var messages = response.messages || [];
            messages.forEach(function (message) {
                appendLi(JSON.stringify(message));
            });
        }).catch(console.error);
}

function clearMessageList(event) {
    event.preventDefault();
    ajax('delete', '/messages').then(function() {
            var ul = document.getElementById('receivedMessages');
            while (ul.hasChildNodes()) {
                ul.removeChild(ul.firstElementChild);
            }
        }).catch(console.error);
}

function broadcastMessage(event) {
    event.preventDefault();
    ajax('post', '/messages', event.target[0].value).catch(console.error);
    event.target[0].value = '';
}

function appendLi(message) {
    var li = document.createElement('LI');
    li.innerHTML = message;
    document.getElementById('receivedMessages').appendChild(li);
}

function ajax(method, url, body) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest();

        xhr.onreadystatechange = function () {
            if (xhr.status >= 200 && xhr.status < 400) {
                resolve(parse(xhr.responseText));
            } else if (status >= 400) {
                reject(parse(xhr.responseText));
            }
        };
        xhr.ontimeout = reject;

        xhr.open(method.toUpperCase(), url);
        xhr.send(body || '');
    });
}

function parse(text) {
    try {
        return JSON.parse(text);
    } catch (error) {
        return text;
    }
}