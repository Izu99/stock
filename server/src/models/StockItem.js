const mongoose = require('mongoose');

const stockItemSchema = mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  name: { type: String, required: true },
  buyPrice: { type: Number, required: true },
  sellPrice: { type: Number, required: true },
  quantity: { type: Number, required: true, default: 0 },
  lowStockThreshold: { type: Number, default: 5.0 },
  minimumLevel: { type: Number, default: 5 }, // Per-item threshold
  barcode: { type: String, unique: true, sparse: true },
  unit: { type: String, enum: ['kg', 'L', 'pcs', 'ml', 'g', 'box', 'carton', 'bottle', 'can'], required: true },
  // Unit conversion support
  bulkUnit: { type: String }, // e.g., "20L drum"
  bulkQuantity: { type: Number }, // e.g., 20
  sellableUnit: { type: String }, // e.g., "500ml bottle"
  sellableQuantity: { type: Number }, // e.g., 0.5
  unitsPerBulk: { type: Number }, // e.g., 40 bottles per drum
  category: { type: String, required: true },
  subcategory: { type: String },
  note: { type: String },
  date: { type: Date, default: Date.now },
}, { timestamps: true });

module.exports = mongoose.model('StockItem', stockItemSchema);
