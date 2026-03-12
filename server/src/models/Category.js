const mongoose = require('mongoose');

const categorySchema = mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  name: { type: String, required: true },
  subcategories: [{ type: String }],
}, { timestamps: true });

// Ensure unique category names per company
categorySchema.index({ companyId: 1, name: 1 }, { unique: true });

module.exports = mongoose.model('Category', categorySchema);
