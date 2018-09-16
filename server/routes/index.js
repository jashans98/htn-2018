const router = require('express').Router();

router.get('/', function(req, res){
  res.send('hi');
});

router.use('/users', require('./users'));
router.use('/build', require('./build'));
router.use('/documents', require('./documents'));
router.use('/convert', require('./convert'));

module.exports = router;
