const mongoose = require('mongoose');

const saleItemSchema = mongoose.Schema({
  item: { type: mongoose.Schema.Types.ObjectId, ref: 'StockItem', required: true },
  itemName: { type: String, required: true },
  quantity: { type: Number, required: true },
  buyPrice: { type: Number, required: true },
  sellPrice: { type: Number, required: true },
  subtotal: { type: Number, required: true },
  profit: { type: Number, required: true },
});

const saleSchema = mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  items: [saleItemSchema],
  totalAmount: { type: Number, required: true },
  totalProfit: { type: Number, required: true },
  billId: { type: String, required: true },
  date: { type: Date, default: Date.now },
}, { timestamps: true });

module.exports = mongoose.model('Sale', saleSchema);

