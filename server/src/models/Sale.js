const mongoose = require('mongoose');

const saleSchema = mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  item: { type: mongoose.Schema.Types.ObjectId, ref: 'StockItem', required: true },
  itemName: { type: String, required: true },
  quantity: { type: Number, required: true },
  sellPrice: { type: Number, required: true },
  subtotal: { type: Number, required: true },
  profit: { type: Number, required: true },
  date: { type: Date, default: Date.now },
}, { timestamps: true });

module.exports = mongoose.model('Sale', saleSchema);
