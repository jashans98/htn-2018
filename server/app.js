const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const routes = require('./routes');

const PORT = process.env.PORT || 5000;

// Allow reading body of requests
// Images are 5MB max
app.use(bodyParser.json({ limit:'10mb' }));
app.use(bodyParser.urlencoded({ extended: false, limit:'10mb' }));

// Connect all our routes to our application
app.use('/', routes);

app.listen(PORT, () => console.log(`Listening on port ${PORT}`));
