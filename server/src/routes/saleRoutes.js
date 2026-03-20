const express = require('express');
const router = express.Router();
const { createSale, getSales, getNextBillId } = require('../controllers/saleController');
const { protect } = require('../middleware/authMiddleware');

router.route('/next-bill-id')
  .get(protect, getNextBillId);

router.route('/')
  .post(protect, createSale)
  .get(protect, getSales);

module.exports = router;
