const Expense = require('../models/Expense');

exports.getExpenses = async (req, res) => {
  console.log(`📋 [ExpenseController] getExpenses called - companyId: ${req.user.companyId}`);
  try {
    const expenses = await Expense.find({ companyId: req.user.companyId }).sort({ date: -1 });
    console.log(`✅ [ExpenseController] Found ${expenses.length} expenses`);
    res.json(expenses);
  } catch (error) {
    console.error(`❌ [ExpenseController] Error getting expenses:`, error.message);
    res.status(500).json({ message: error.message });
  }
};

exports.addExpense = async (req, res) => {
  console.log(`➕ [ExpenseController] addExpense called - data:`, JSON.stringify(req.body));
  try {
    const expenseData = { ...req.body };
    delete expenseData._id;

    const expense = await Expense.create({
      ...expenseData,
      companyId: req.user.companyId
    });
    console.log(`✅ [ExpenseController] Expense added - id: ${expense._id}, title: ${expense.title}, amount: ${expense.amount}`);
    res.status(201).json(expense);
  } catch (error) {
    console.error(`❌ [ExpenseController] Error adding expense:`, error.message);
    res.status(400).json({ message: error.message });
  }
};

exports.updateExpense = async (req, res) => {
  console.log(`✏️ [ExpenseController] updateExpense called - id: ${req.params.id}`);
  try {
    const updateData = { ...req.body };
    delete updateData.companyId;
    delete updateData._id;

    const expense = await Expense.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      updateData,
      { returnDocument: 'after' }
    );
    if (!expense) {
      console.log(`❌ [ExpenseController] Expense not found for update - id: ${req.params.id}`);
      return res.status(404).json({ message: 'Expense not found' });
    }
    console.log(`✅ [ExpenseController] Expense updated - id: ${expense._id}`);
    res.json(expense);
  } catch (error) {
    console.error(`❌ [ExpenseController] Error updating expense:`, error.message);
    res.status(400).json({ message: error.message });
  }
};

exports.deleteExpense = async (req, res) => {
  console.log(`🗑️ [ExpenseController] deleteExpense called - id: ${req.params.id}`);
  try {
    const expense = await Expense.findOneAndDelete({ _id: req.params.id, companyId: req.user.companyId });
    if (!expense) {
      console.log(`❌ [ExpenseController] Expense not found for delete - id: ${req.params.id}`);
      return res.status(404).json({ message: 'Expense not found' });
    }
    console.log(`✅ [ExpenseController] Expense deleted - id: ${expense._id}`);
    res.json({ message: 'Expense deleted' });
  } catch (error) {
    console.error(`❌ [ExpenseController] Error deleting expense:`, error.message);
    res.status(500).json({ message: error.message });
  }
};
