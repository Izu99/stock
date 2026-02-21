const StockItem = require('../models/StockItem');

exports.getStockItems = async (req, res) => {
  console.log(`📦 [StockController] getStockItems called - companyId: ${req.user.companyId}`);
  try {
    const items = await StockItem.find({ companyId: req.user.companyId }).sort({ createdAt: -1 });
    console.log(`✅ [StockController] Found ${items.length} stock items`);
    res.json(items);
  } catch (error) {
    console.error(`❌ [StockController] Error getting items:`, error.message);
    res.status(500).json({ message: error.message });
  }
};

exports.addStockItem = async (req, res) => {
  console.log(`➕ [StockController] addStockItem called - data:`, JSON.stringify(req.body));
  try {
    const stockData = { ...req.body };
    delete stockData._id; // Ensure we don't try to save an empty string as _id

    const item = new StockItem({
      ...stockData,
      companyId: req.user.companyId
    });
    const savedItem = await item.save();
    console.log(`✅ [StockController] Item added - id: ${savedItem._id}, name: ${savedItem.name}`);
    res.status(201).json(savedItem);
  } catch (error) {
    console.error(`❌ [StockController] Error adding item:`, error.message);
    res.status(400).json({ message: error.message });
  }
};

exports.updateStockItem = async (req, res) => {
  console.log(`✏️ [StockController] updateStockItem called - id: ${req.params.id}, data:`, JSON.stringify(req.body));
  try {
    const updateData = { ...req.body };
    delete updateData.companyId; 
    delete updateData._id;

    const item = await StockItem.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      updateData,
      { returnDocument: 'after' }
    );
    if (!item) {
      console.log(`❌ [StockController] Item not found for update - id: ${req.params.id}`);
      return res.status(404).json({ message: 'Item not found' });
    }
    console.log(`✅ [StockController] Item updated - id: ${item._id}, name: ${item.name}`);
    res.json(item);
  } catch (error) {
    console.error(`❌ [StockController] Error updating item:`, error.message);
    res.status(400).json({ message: error.message });
  }
};

exports.deleteStockItem = async (req, res) => {
  console.log(`🗑️ [StockController] deleteStockItem called - id: ${req.params.id}`);
  try {
    const item = await StockItem.findOneAndDelete({ _id: req.params.id, companyId: req.user.companyId });
    if (!item) {
      console.log(`❌ [StockController] Item not found for delete - id: ${req.params.id}`);
      return res.status(404).json({ message: 'Item not found' });
    }
    console.log(`✅ [StockController] Item deleted - id: ${item._id}, name: ${item.name}`);
    res.json({ message: 'Item deleted' });
  } catch (error) {
    console.error(`❌ [StockController] Error deleting item:`, error.message);
    res.status(500).json({ message: error.message });
  }
};
