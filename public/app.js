var socket = new WebSocket('ws://' + window.location.host + '/simulator');

socket.onmessage = function (message) {
    var data = parse(message.data);

    if (data.clientCount !== undefined) {
        document.getElementById('clientCount').innerHTML = data.clientCount;
    } else if (data.newMessage !== undefined) {
        appendLi(data.newMessage);
    }
};

getMessages();

function getMessages() {
    ajax('get', '/messages').then(function (response) {
        var messages = response.messages || [];
        messages.forEach(function (message) {
            appendLi(JSON.stringify(message));
        });
    }).catch(console.error);
}

function clearMessageList(event) {
    event.preventDefault();
    ajax('delete', '/messages').then(function () {
        var ul = document.getElementById('receivedMessages');
        while (ul.hasChildNodes()) {
            ul.removeChild(ul.firstElementChild);
        }
    }).catch(console.error);
}

function broadcastMessage(event) {
    var value = event.target[0].value;
    event.preventDefault();
    try {
        JSON.parse(value);
        ajax('post', '/messages', value).catch(console.error);
        event.target[0].value = '';
    } catch (error) {
        changeText('error');
    }
}

function changeText(value) {
    var input = document.querySelector('#formInvalidator');
    input.value = value || '';
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
            if (xhr.readyState === 4) {
                if (status >= 400) {
                    reject(parse(xhr.responseText));
                } else if (xhr.status >= 200) {
                    resolve(parse(xhr.responseText));
                }
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
