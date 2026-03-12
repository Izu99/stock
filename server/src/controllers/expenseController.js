const Expense = require('../models/Expense');

exports.getExpenses = async (req, res) => {
  console.log(`⚙️ [Expense] Process started: Fetching expenses for company ${req.user.companyId}...`);
  try {
    const expenses = await Expense.find({ companyId: req.user.companyId }).sort({ date: -1 });
    console.log(`✨ [Expense] Process complete: Found ${expenses.length} records`);
    res.json(expenses);
  } catch (error) {
    console.error(`💥 [Expense] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

exports.addExpense = async (req, res) => {
  console.log(`⚙️ [Expense] Process started: Adding new expense...`);
  try {
    const expenseData = { ...req.body };
    delete expenseData._id;

    console.log(`💾 [Expense] Database operation: Saving record ${expenseData.title}...`);
    const expense = await Expense.create({
      ...expenseData,
      companyId: req.user.companyId
    });
    console.log(`✨ [Expense] Process complete: Expense saved (ID: ${expense._id})`);
    res.status(201).json(expense);
  } catch (error) {
    console.error(`💥 [Expense] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.updateExpense = async (req, res) => {
  const id = req.params.id;
  console.log(`⚙️ [Expense] Process started: Updating expense ${id}...`);
  try {
    const updateData = { ...req.body };
    delete updateData.companyId;
    delete updateData._id;

    console.log(`💾 [Expense] Database operation: Updating record in DB...`);
    const expense = await Expense.findOneAndUpdate(
      { _id: id, companyId: req.user.companyId },
      updateData,
      { returnDocument: 'after' }
    );
    if (!expense) {
      console.log(`❌ [Expense] Process halted: Expense ${id} not found`);
      return res.status(404).json({ message: 'Expense not found' });
    }
    console.log(`✨ [Expense] Process complete: Expense updated`);
    res.json(expense);
  } catch (error) {
    console.error(`💥 [Expense] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.deleteExpense = async (req, res) => {
  const id = req.params.id;
  console.log(`⚙️ [Expense] Process started: Deleting expense ${id}...`);
  try {
    console.log(`💾 [Expense] Database operation: Removing record...`);
    const expense = await Expense.findOneAndDelete({ _id: id, companyId: req.user.companyId });
    if (!expense) {
      console.log(`❌ [Expense] Process halted: Expense ${id} not found`);
      return res.status(404).json({ message: 'Expense not found' });
    }
    console.log(`✨ [Expense] Process complete: Expense removed`);
    res.json({ message: 'Expense deleted' });
  } catch (error) {
    console.error(`💥 [Expense] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};
