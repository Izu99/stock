const mongoose = require('mongoose');

const stockItemSchema = mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  name: { type: String, required: true },
  buyPrice: { type: Number, required: true },
  sellPrice: { type: Number, required: true },
  quantity: { type: Number, required: true, default: 0 },
  unit: { type: String, enum: ['kg', 'L', 'pcs'], required: true },
  category: { type: String, required: true },
  subcategory: { type: String },
  note: { type: String },
  date: { type: Date, default: Date.now },
}, { timestamps: true });

module.exports = mongoose.model('StockItem', stockItemSchema);
