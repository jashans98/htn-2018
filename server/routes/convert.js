const ConvertRouter = require('express').Router();
const myscript = require('../core/myscript');

ConvertRouter.post('/math', async function(req, res) {
    console.log('calling function');
    const resp = await myscript.translate(req.body); 
    console.log('done calling!');
    console.log(resp);
    res.json(resp);
});

module.exports = ConvertRouter;
