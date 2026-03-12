const mongoose = require('mongoose');

const expenseSchema = mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  title: { type: String, required: true },
  amount: { type: Number, required: true },
  category: { 
    type: String, 
    enum: [
      'hardware', 
      'utility_bills', 
      'stock_purchase', 
      'salary', 
      'maintenance', 
      'rent', 
      'transport',
      'marketing',
      'other'
    ], 
    required: true 
  },
  note: { type: String },
  date: { type: Date, default: Date.now },
}, { timestamps: true });

module.exports = mongoose.model('Expense', expenseSchema);
