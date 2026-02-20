const Sale = require('../models/Sale');
const StockItem = require('../models/StockItem');

exports.createSale = async (req, res) => {
  const { itemId, quantity } = req.body;
  try {
    const item = await StockItem.findOne({ _id: itemId, companyId: req.user.companyId });
    if (!item) return res.status(404).json({ message: 'Item not found' });
    if (item.quantity < quantity) return res.status(400).json({ message: 'Insufficient stock' });

    const subtotal = item.sellPrice * quantity;
    const profit = (item.sellPrice - item.buyPrice) * quantity;

    const sale = await Sale.create({
      companyId: req.user.companyId,
      item: item._id,
      itemName: item.name,
      quantity,
      sellPrice: item.sellPrice,
      subtotal,
      profit,
    });

    // Reduce stock
    item.quantity -= quantity;
    await item.save();

    res.status(201).json(sale);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getSales = async (req, res) => {
  try {
    const sales = await Sale.find({ companyId: req.user.companyId }).sort({ date: -1 });
    res.json(sales);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
