const express = require('express');
const router = express.Router();
const { getStockItems, addStockItem, updateStockItem, deleteStockItem } = require('../controllers/stockController');
const { protect } = require('../middleware/authMiddleware');

router.route('/')
  .get(protect, getStockItems)
  .post(protect, addStockItem);

router.route('/:id')
  .put(protect, updateStockItem)
  .delete(protect, deleteStockItem);

module.exports = router;
