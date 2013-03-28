var http = require('http'),
    winston = require('winston'),
    ioclient = require('socket.io-client');

var logger = new (winston.Logger)({
        transports: [ new winston.transports.Console({ level:'info' }) ],
        levels: {
            debug: 0,
            info: 1,
            error: 2
        }
    });

// gateway: url
// callback(err, socket, publicUrl)
function connectToPrezGateway(gateway, seed, localHttpPort, callback) {

    var publicUrl = '';
    var socket = ioclient.connect(gateway);

    socket.on('connect', function() {

        logger.debug('socket.io client connected to gateway');

        socket.emit('register', seed, function(id) {
            publicUrl = gateway + '/' + id;
            logger.debug('Prez registered, public url: ' + publicUrl);
            callback(null, socket, publicUrl);
        });
    });

    socket.on('httprequest', function(data) {

        var req = data.req;
        // Fix hostname/port to reflect our own local server
        req.hostname = 'localhost';
        req.port = localHttpPort;
        req.headers.host = req.hostname + ':' + req.port;

        logger.debug('Received HTTP request over socket.io: path: ' + req.path +
                     ', forwarding to local server');
        var hreq = http.request(req, function(res) {
            logger.debug('Response from local server: HTTP status code ' + res.statusCode);

            var hData = { id: data.id, statusCode: res.statusCode, headers: res.headers };
            socket.emit('httpresponseheaders', hData);

            res.on('data', function (chunk) {
                logger.debug('Body chunk length =', chunk.length);
                socket.emit('httpresponsedata', { id: data.id, chunk:chunk.toString('base64') });
            });
            res.on('end', function() {
                logger.debug('Body end');
                socket.emit('httpresponseend', { id: data.id });
            });
        });
        hreq.end();
    });
}

var PrezAt = {
    connectToPrezGateway: connectToPrezGateway
}

module.exports = PrezAt;
