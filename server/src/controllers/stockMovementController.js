const StockMovement = require('../models/StockMovement');
const StockItem = require('../models/StockItem');
const { asyncHandler } = require('../middleware/errorHandler');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { withTransaction } = require('../utils/transaction');
const logger = require('../utils/logger');

// Get stock movement history for an item
exports.getStockMovementHistory = asyncHandler(async (req, res) => {
  const { stockItemId } = req.params;
  const { startDate, endDate, type } = req.query;

  const query = { 
    stockItemId,
    companyId: req.user.companyId 
  };

  if (startDate || endDate) {
    query.date = {};
    if (startDate) query.date.$gte = new Date(startDate);
    if (endDate) query.date.$lte = new Date(endDate);
  }

  if (type) {
    query.type = type;
  }

  const movements = await StockMovement.find(query)
    .populate('performedBy', 'username')
    .sort({ date: -1 })
    .limit(100);

  res.json({ success: true, data: movements });
});

// Get all stock movements (for reports)
exports.getAllStockMovements = asyncHandler(async (req, res) => {
  const { startDate, endDate, type } = req.query;

  const query = { companyId: req.user.companyId };

  if (startDate || endDate) {
    query.date = {};
    if (startDate) query.date.$gte = new Date(startDate);
    if (endDate) query.date.$lte = new Date(endDate);
  }

  if (type) {
    query.type = type;
  }

  const movements = await StockMovement.find(query)
    .populate('stockItemId', 'name category')
    .populate('performedBy', 'username')
    .sort({ date: -1 })
    .limit(500);

  res.json({ success: true, data: movements });
});

// Record stock adjustment (manual increase/decrease)
exports.recordStockAdjustment = asyncHandler(async (req, res) => {
  const { stockItemId, quantity, reason, notes } = req.body;

  if (!stockItemId || quantity === undefined) {
    throw new ValidationError('Stock item ID and quantity are required');
  }

  const result = await withTransaction(async (session) => {
    const stockItem = await StockItem.findOne({
      _id: stockItemId,
      companyId: req.user.companyId
    }).session(session);

    if (!stockItem) {
      throw new NotFoundError('Stock item not found');
    }

    const quantityBefore = stockItem.quantity;
    const quantityAfter = quantityBefore + quantity;

    if (quantityAfter < 0) {
      throw new ValidationError('Insufficient stock for this adjustment');
    }

    stockItem.quantity = quantityAfter;
    await stockItem.save({ session });

    const movement = await StockMovement.create([{
      companyId: req.user.companyId,
      stockItemId,
      type: 'adjustment',
      quantity: Math.abs(quantity),
      quantityBefore,
      quantityAfter,
      reason,
      notes,
      performedBy: req.user.id
    }], { session });

    logger.info('Stock adjustment recorded', {
      stockItemId,
      quantity,
      performedBy: req.user.id
    });

    return { stockItem, movement: movement[0] };
  });

  res.status(201).json({ 
    success: true, 
    data: result 
  });
});

// Record wastage/damage
exports.recordWastage = asyncHandler(async (req, res) => {
  const { stockItemId, quantity, reason, notes } = req.body;

  if (!stockItemId || !quantity || quantity <= 0) {
    throw new ValidationError('Stock item ID and positive quantity are required');
  }

  const result = await withTransaction(async (session) => {
    const stockItem = await StockItem.findOne({
      _id: stockItemId,
      companyId: req.user.companyId
    }).session(session);

    if (!stockItem) {
      throw new NotFoundError('Stock item not found');
    }

    if (stockItem.quantity < quantity) {
      throw new ValidationError('Insufficient stock to record wastage');
    }

    const quantityBefore = stockItem.quantity;
    const quantityAfter = quantityBefore - quantity;

    stockItem.quantity = quantityAfter;
    await stockItem.save({ session });

    const movement = await StockMovement.create([{
      companyId: req.user.companyId,
      stockItemId,
      type: 'wastage',
      quantity,
      quantityBefore,
      quantityAfter,
      unitPrice: stockItem.buyPrice,
      totalValue: quantity * stockItem.buyPrice,
      reason,
      notes,
      performedBy: req.user.id
    }], { session });

    logger.warn('Wastage recorded', {
      stockItemId,
      quantity,
      value: quantity * stockItem.buyPrice,
      performedBy: req.user.id
    });

    return { stockItem, movement: movement[0] };
  });

  res.status(201).json({ 
    success: true, 
    data: result 
  });
});

// Get wastage report
exports.getWastageReport = asyncHandler(async (req, res) => {
  const { startDate, endDate } = req.query;

  const query = { 
    companyId: req.user.companyId,
    type: { $in: ['wastage', 'damage'] }
  };

  if (startDate || endDate) {
    query.date = {};
    if (startDate) query.date.$gte = new Date(startDate);
    if (endDate) query.date.$lte = new Date(endDate);
  }

  const wastageMovements = await StockMovement.find(query)
    .populate('stockItemId', 'name category unit')
    .populate('performedBy', 'username')
    .sort({ date: -1 });

  const totalWastageValue = wastageMovements.reduce((sum, m) => sum + (m.totalValue || 0), 0);
  const totalWastageQuantity = wastageMovements.reduce((sum, m) => sum + m.quantity, 0);

  // Group by category
  const byCategory = {};
  wastageMovements.forEach(m => {
    const category = m.stockItemId?.category || 'Unknown';
    if (!byCategory[category]) {
      byCategory[category] = { count: 0, value: 0 };
    }
    byCategory[category].count += m.quantity;
    byCategory[category].value += m.totalValue || 0;
  });

  res.json({ 
    success: true, 
    data: {
      movements: wastageMovements,
      summary: {
        totalWastageValue,
        totalWastageQuantity,
        byCategory
      }
    }
  });
});

module.exports = exports;
