const express = require('express');
const router = express.Router();
const stockMovementController = require('../controllers/stockMovementController');
const { protect } = require('../middleware/authMiddleware');
const { idValidator, dateRangeValidator } = require('../middleware/validators');

// All routes require authentication
router.use(protect);

// Get movement history for a specific item
router.get('/item/:stockItemId', idValidator, stockMovementController.getStockMovementHistory);

// Get all movements (for reports)
router.get('/', dateRangeValidator, stockMovementController.getAllStockMovements);

// Record stock adjustment
router.post('/adjustment', stockMovementController.recordStockAdjustment);

// Record wastage/damage
router.post('/wastage', stockMovementController.recordWastage);

// Get wastage report
router.get('/wastage/report', dateRangeValidator, stockMovementController.getWastageReport);

module.exports = router;
