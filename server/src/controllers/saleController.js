const Sale = require('../models/Sale');
const StockItem = require('../models/StockItem');
const StockMovement = require('../models/StockMovement');
const { asyncHandler } = require('../middleware/errorHandler');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { withTransaction } = require('../utils/transaction');
const logger = require('../utils/logger');

exports.createSale = asyncHandler(async (req, res) => {
  const { items: requestItems, billId } = req.body;
  
  if (!requestItems || !Array.isArray(requestItems)) {
    throw new ValidationError('Items array is required');
  }

  logger.info('Creating new sale bill', { billId, itemCount: requestItems.length, userId: req.user.id });
  
  const result = await withTransaction(async (session) => {
    let totalBillAmount = 0;
    let totalBillProfit = 0;
    const saleItems = [];

    const movementsToCreate = [];

    for (const reqItem of requestItems) {
      const { itemId, quantity, sellPrice: customSellPrice } = reqItem;
      
      const item = await StockItem.findOne({ 
        _id: itemId, 
        companyId: req.user.companyId 
      }).session(session);
      
      if (!item) {
        throw new NotFoundError(`Stock item with ID ${itemId} not found`);
      }
      
      if (item.quantity < quantity) {
        throw new ValidationError(`Insufficient stock for item: ${item.name}`);
      }

      const actualSellPrice = customSellPrice != null && customSellPrice > 0 ? customSellPrice : item.sellPrice;
      const subtotal = actualSellPrice * quantity;
      const profit = (actualSellPrice - item.buyPrice) * quantity;

      totalBillAmount += subtotal;
      totalBillProfit += profit;

      saleItems.push({
        item: item._id,
        itemName: item.name,
        quantity,
        buyPrice: item.buyPrice,
        sellPrice: actualSellPrice,
        subtotal,
        profit,
      });

      const quantityBefore = item.quantity;
      item.quantity -= quantity;
      await item.save({ session });

      movementsToCreate.push({
        companyId: req.user.companyId,
        stockItemId: item._id,
        type: 'sale',
        quantity,
        quantityBefore,
        quantityAfter: item.quantity,
        unitPrice: actualSellPrice,
        totalValue: subtotal,
        referenceType: 'Sale',
        performedBy: req.user.id
      });
    }

    // Create the Sale document
    const sale = await Sale.create([{
      companyId: req.user.companyId,
      items: saleItems,
      totalAmount: totalBillAmount,
      totalProfit: totalBillProfit,
      billId,
    }], { session, ordered: true });

    const createdSale = sale[0];



    // Create all stock movements linked to this sale
    if (movementsToCreate.length > 0) {
      const movementsWithRef = movementsToCreate.map(m => ({
        ...m,
        referenceId: createdSale._id
      }));
      await StockMovement.insertMany(movementsWithRef, { session });
    }

    logger.info('Sale bill created successfully', { saleId: createdSale._id, billId: createdSale.billId });
    return createdSale;


  });

  res.status(201).json(result);
});

exports.getSales = asyncHandler(async (req, res) => {
  logger.info('Fetching sales history', { userId: req.user.id });
  
  const sales = await Sale.find({ companyId: req.user.companyId }).sort({ date: -1 });
  
  res.json(sales);
});

// Get next available sequential bill ID grouped by company
exports.getNextBillId = asyncHandler(async (req, res) => {
  // Find the last sale that has a billId, sorted by creation date descending
  const lastSale = await Sale.findOne({ 
    companyId: req.user.companyId,
    billId: { $ne: null }
  }).sort({ createdAt: -1 });

  let nextNumber = 1;

  if (lastSale && lastSale.billId) {
    const numMatch = lastSale.billId.match(/\d+$/);
    if (numMatch) {
      const currentVal = parseInt(numMatch[0], 10);
      // If previous number is from the old random millisecond format (> 5 digits), reset to 1
      if (currentVal > 99999) {
        nextNumber = 1;
      } else {
        nextNumber = currentVal + 1;
      }
    }
  }

  // Format as 3-digit padded number: 001, 002, 003...
  const nextBillId = String(nextNumber).padStart(3, '0');
  
  res.status(200).json({ success: true, data: nextBillId });
});
