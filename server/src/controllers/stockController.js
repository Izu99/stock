const StockItem = require('../models/StockItem');

exports.getStockItems = async (req, res) => {
  try {
    const items = await StockItem.find({ companyId: req.user.companyId }).sort({ createdAt: -1 });
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.addStockItem = async (req, res) => {
  try {
    const stockData = { ...req.body };
    delete stockData._id; // Ensure we don't try to save an empty string as _id

    const item = new StockItem({
      ...stockData,
      companyId: req.user.companyId
    });
    const savedItem = await item.save();
    res.status(201).json(savedItem);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.updateStockItem = async (req, res) => {
  try {
    const updateData = { ...req.body };
    delete updateData.companyId; 
    delete updateData._id;

    const item = await StockItem.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      updateData,
      { returnDocument: 'after' }
    );
    if (!item) return res.status(404).json({ message: 'Item not found' });
    res.json(item);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.deleteStockItem = async (req, res) => {
  try {
    const item = await StockItem.findOneAndDelete({ _id: req.params.id, companyId: req.user.companyId });
    if (!item) return res.status(404).json({ message: 'Item not found' });
    res.json({ message: 'Item deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
