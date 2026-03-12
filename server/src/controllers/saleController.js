const Sale = require('../models/Sale');
const StockItem = require('../models/StockItem');
const StockMovement = require('../models/StockMovement');
const { asyncHandler } = require('../middleware/errorHandler');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { withTransaction } = require('../utils/transaction');
const logger = require('../utils/logger');

exports.createSale = asyncHandler(async (req, res) => {
  const { itemId, quantity, sellPrice: customSellPrice } = req.body;
  
  logger.info('Creating new sale', { itemId, quantity, userId: req.user.id });
  
  const result = await withTransaction(async (session) => {
    const item = await StockItem.findOne({ 
      _id: itemId, 
      companyId: req.user.companyId 
    }).session(session);
    
    if (!item) {
      throw new NotFoundError('Item not found');
    }
    
    if (item.quantity < quantity) {
      throw new ValidationError('Insufficient stock');
    }

    const actualSellPrice = customSellPrice != null && customSellPrice > 0 ? customSellPrice : item.sellPrice;
    const subtotal = actualSellPrice * quantity;
    const profit = (actualSellPrice - item.buyPrice) * quantity;

    const sale = await Sale.create([{
      companyId: req.user.companyId,
      item: item._id,
      itemName: item.name,
      quantity,
      sellPrice: actualSellPrice,
      subtotal,
      profit,
    }], { session });

    const quantityBefore = item.quantity;
    item.quantity -= quantity;
    await item.save({ session });

    // Record stock movement
    await StockMovement.create([{
      companyId: req.user.companyId,
      stockItemId: item._id,
      type: 'sale',
      quantity,
      quantityBefore,
      quantityAfter: item.quantity,
      unitPrice: actualSellPrice,
      totalValue: subtotal,
      referenceId: sale[0]._id,
      referenceType: 'Sale',
      performedBy: req.user.id
    }], { session });

    logger.info('Sale created successfully', { saleId: sale[0]._id });
    return sale[0];
  });

  res.status(201).json(result);
});

exports.getSales = asyncHandler(async (req, res) => {
  logger.info('Fetching sales history', { userId: req.user.id });
  
  const sales = await Sale.find({ companyId: req.user.companyId }).sort({ date: -1 });
  
  res.json(sales);
});
