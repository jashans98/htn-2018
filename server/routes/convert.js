const ConvertRouter = require('express').Router();
const myscript = require('../core/myscript');

ConvertRouter.post('/math', async function(req, res) {
    const resp = await myscript.translate(req.body);
    res.json(resp);
});

module.exports = ConvertRouter;
