const Expense = require('../models/Expense');

exports.getExpenses = async (req, res) => {
  try {
    const expenses = await Expense.find({ companyId: req.user.companyId }).sort({ date: -1 });
    res.json(expenses);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.addExpense = async (req, res) => {
  try {
    const expenseData = { ...req.body };
    delete expenseData._id;

    const expense = await Expense.create({
      ...expenseData,
      companyId: req.user.companyId
    });
    res.status(201).json(expense);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.updateExpense = async (req, res) => {
  try {
    const updateData = { ...req.body };
    delete updateData.companyId;
    delete updateData._id;

    const expense = await Expense.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      updateData,
      { returnDocument: 'after' }
    );
    if (!expense) return res.status(404).json({ message: 'Expense not found' });
    res.json(expense);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.deleteExpense = async (req, res) => {
  try {
    const expense = await Expense.findOneAndDelete({ _id: req.params.id, companyId: req.user.companyId });
    if (!expense) return res.status(404).json({ message: 'Expense not found' });
    res.json({ message: 'Expense deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
