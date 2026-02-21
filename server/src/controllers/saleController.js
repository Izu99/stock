const Sale = require('../models/Sale');
const StockItem = require('../models/StockItem');

exports.createSale = async (req, res) => {
  const { itemId, quantity, sellPrice: customSellPrice } = req.body;
  console.log(`📦 [SaleController] createSale called - itemId: ${itemId}, quantity: ${quantity}, customPrice: ${customSellPrice || 'default'}, companyId: ${req.user.companyId}`);
  
  try {
    const item = await StockItem.findOne({ _id: itemId, companyId: req.user.companyId });
    
    if (!item) {
      console.log(`❌ [SaleController] Item not found - itemId: ${itemId}`);
      return res.status(404).json({ message: 'Item not found' });
    }
    
    console.log(`📋 [SaleController] Found item: ${item.name}, currentStock: ${item.quantity}, requestedQty: ${quantity}`);
    
    if (item.quantity < quantity) {
      console.log(`⚠️ [SaleController] Insufficient stock - available: ${item.quantity}, requested: ${quantity}`);
      return res.status(400).json({ message: 'Insufficient stock' });
    }

    // Use custom sell price if provided, otherwise use item's default sell price
    const actualSellPrice = customSellPrice != null && customSellPrice > 0 
      ? customSellPrice 
      : item.sellPrice;
    
    const subtotal = actualSellPrice * quantity;
    const profit = (actualSellPrice - item.buyPrice) * quantity;

    console.log(`💰 [SaleController] Creating sale - price: ${actualSellPrice} (${customSellPrice ? 'custom' : 'default'}), subtotal: ${subtotal}, profit: ${profit}`);

    const sale = await Sale.create({
      companyId: req.user.companyId,
      item: item._id,
      itemName: item.name,
      quantity,
      sellPrice: actualSellPrice,
      subtotal,
      profit,
    });

    // Reduce stock
    const oldQty = item.quantity;
    item.quantity -= quantity;
    await item.save();

    console.log(`✅ [SaleController] Sale created - saleId: ${sale._id}, price: ${actualSellPrice}, stock: ${oldQty} → ${item.quantity}`);

    res.status(201).json(sale);
  } catch (error) {
    console.error(`❌ [SaleController] Error creating sale:`, error.message, error.stack);
    res.status(500).json({ message: error.message });
  }
};

exports.getSales = async (req, res) => {
  console.log(`📊 [SaleController] getSales called - companyId: ${req.user.companyId}`);
  try {
    const sales = await Sale.find({ companyId: req.user.companyId }).sort({ date: -1 });
    console.log(`✅ [SaleController] Found ${sales.length} sales`);
    res.json(sales);
  } catch (error) {
    console.error(`❌ [SaleController] Error getting sales:`, error.message);
    res.status(500).json({ message: error.message });
  }
};
