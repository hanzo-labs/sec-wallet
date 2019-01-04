    var fs = require('fs'),
    https = require('https'),
    express = require('express'),
    app = express();

    https.createServer({
      key: fs.readFileSync('key.pem'),
      cert: fs.readFileSync('cert.pem')
    }, app).listen(55555);

    app.use(express.static(__dirname + '/public', { extensions: ['html', 'htm'] }));
