const express = require('express');
const router = express.Router();
const analyticsController = require('../controllers/analyticsController');
const { protect } = require('../middleware/authMiddleware');
const { dateRangeValidator } = require('../middleware/validators');

// All routes require authentication
router.use(protect);

// Profitability
router.get('/profitability/items', dateRangeValidator, analyticsController.getItemProfitability);
router.get('/profitability/categories', dateRangeValidator, analyticsController.getCategoryProfitability);

// Cash flow forecast
router.get('/forecast/cashflow', analyticsController.getCashFlowForecast);

// Inventory valuation
router.get('/inventory/valuation', analyticsController.getInventoryValuation);

// Top selling items
router.get('/top-sellers', dateRangeValidator, analyticsController.getTopSellingItems);

// Items to reorder
router.get('/reorder-list', analyticsController.getItemsToReorder);

module.exports = router;
