const StockItem = require('../models/StockItem');

exports.getStockItems = async (req, res) => {
  console.log(`⚙️ [Stock] Process started: Fetching items for company ${req.user.companyId}...`);
  try {
    console.log(`🔍 [Stock] Database check: Retrieving all stock items...`);
    const items = await StockItem.find({ companyId: req.user.companyId }).sort({ createdAt: -1 });
    console.log(`✨ [Stock] Process complete: Found ${items.length} items`);
    res.json(items);
  } catch (error) {
    console.error(`💥 [Stock] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

exports.addStockItem = async (req, res) => {
  console.log(`⚙️ [Stock] Process started: Adding new item...`);
  try {
    const { barcode, name } = req.body;
    
    if (barcode && barcode.trim().length > 0) {
      console.log(`🔍 [Stock] Database check: Verifying barcode unique (${barcode})...`);
      const existing = await StockItem.findOne({ barcode, companyId: req.user.companyId });
      if (existing) {
        console.log(`⚠️ [Stock] Process halted: Duplicate barcode detected`);
        return res.status(400).json({ message: 'An item with this barcode already exists' });
      }
    }

    const stockData = { ...req.body };
    delete stockData._id; 

    console.log(`💾 [Stock] Database operation: Saving item ${name}...`);
    const item = new StockItem({
      ...stockData,
      companyId: req.user.companyId
    });
    const savedItem = await item.save();
    
    console.log(`✨ [Stock] Process complete: Item saved (ID: ${savedItem._id})`);
    res.status(201).json(savedItem);
  } catch (error) {
    console.error(`💥 [Stock] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.updateStockItem = async (req, res) => {
  const id = req.params.id;
  console.log(`⚙️ [Stock] Process started: Updating item ${id}...`);
  try {
    const { barcode } = req.body;

    if (barcode) {
      console.log(`🔍 [Stock] Database check: Verifying barcode availability...`);
      const existing = await StockItem.findOne({ barcode, _id: { $ne: id }, companyId: req.user.companyId });
      if (existing) {
        console.log(`⚠️ [Stock] Process halted: Barcode already in use`);
        return res.status(400).json({ message: 'Another item is already using this barcode' });
      }
    }

    const updateData = { ...req.body };
    delete updateData.companyId; 
    delete updateData._id;

    console.log(`💾 [Stock] Database operation: Updating record in DB...`);
    const item = await StockItem.findOneAndUpdate(
      { _id: id, companyId: req.user.companyId },
      updateData,
      { returnDocument: 'after' }
    );
    
    if (!item) {
      console.log(`❌ [Stock] Process halted: Item ${id} not found`);
      return res.status(404).json({ message: 'Item not found' });
    }
    
    console.log(`✨ [Stock] Process complete: Item ${item.name} updated`);
    res.json(item);
  } catch (error) {
    console.error(`💥 [Stock] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.deleteStockItem = async (req, res) => {
  const id = req.params.id;
  console.log(`⚙️ [Stock] Process started: Deleting item ${id}...`);
  try {
    console.log(`💾 [Stock] Database operation: Removing record...`);
    const item = await StockItem.findOneAndDelete({ _id: id, companyId: req.user.companyId });
    if (!item) {
      console.log(`❌ [Stock] Process halted: Item ${id} not found`);
      return res.status(404).json({ message: 'Item not found' });
    }
    console.log(`✨ [Stock] Process complete: Item removed`);
    res.json({ message: 'Item deleted' });
  } catch (error) {
    console.error(`💥 [Stock] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};
