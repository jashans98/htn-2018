const router = require('express').Router();

router.get('/', function(req, res){
  res.send('hi');
});

router.use('/users', require('./users'));
router.use('/documents', require('./documents'));

module.exports = router;
