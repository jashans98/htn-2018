const ConvertRouter = require('express').Router();
const myscript = require('../core/myscript');
const build    = require('../core/build');
const { Text, Math } = require('../core/blocks');

ConvertRouter.post('/math', async function(req, res) {
    const resp = await myscript.translate(req.body);
    res.json(resp);
});

ConvertRouter.post('/build/:filename', async (req, res) => {
    let {
        blocks
    } = JSON.parse(JSON.stringify(req.body));

    blocks = blocks.map(block => {
        if (block.type === 'text') {
            return new Text(block.data);
        } else {
            return new Math(block.data, block.width, block.height);
        }
    });

    await console.log('About to call build');
    const response = await build(blocks, req.params.filename);
    await console.log('Finished calling build');
    
    res.json(response);
    return response;
});

module.exports = ConvertRouter;
