const mongoose = require('mongoose');

const stockMovementSchema = mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  stockItemId: { type: mongoose.Schema.Types.ObjectId, ref: 'StockItem', required: true },
  type: { 
    type: String, 
    enum: ['purchase', 'sale', 'adjustment', 'damage', 'wastage', 'return'], 
    required: true 
  },
  quantity: { type: Number, required: true },
  quantityBefore: { type: Number, required: true },
  quantityAfter: { type: Number, required: true },
  unitPrice: { type: Number },
  totalValue: { type: Number },
  reason: { type: String },
  notes: { type: String },
  referenceId: { type: mongoose.Schema.Types.ObjectId }, // Sale ID, Purchase ID, etc.
  referenceType: { type: String }, // 'Sale', 'Purchase', etc.
  performedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  date: { type: Date, default: Date.now }
}, { timestamps: true });

// Index for faster queries
stockMovementSchema.index({ stockItemId: 1, date: -1 });
stockMovementSchema.index({ companyId: 1, type: 1, date: -1 });

module.exports = mongoose.model('StockMovement', stockMovementSchema);
