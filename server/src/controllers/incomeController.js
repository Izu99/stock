const Income = require('../models/Income');

exports.getIncomes = async (req, res) => {
  console.log(`⚙️ [Income] Process started: Fetching income records for company ${req.user.companyId}...`);
  try {
    const incomes = await Income.find({ companyId: req.user.companyId }).sort({ date: -1 });
    console.log(`✨ [Income] Process complete: Found ${incomes.length} records`);
    res.json(incomes);
  } catch (error) {
    console.error(`💥 [Income] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

exports.addIncome = async (req, res) => {
  console.log(`⚙️ [Income] Process started: Adding new income record...`);
  try {
    const incomeData = { ...req.body };
    delete incomeData._id;

    console.log(`💾 [Income] Database operation: Saving record ${incomeData.title}...`);
    const income = await Income.create({
      ...incomeData,
      companyId: req.user.companyId
    });
    console.log(`✨ [Income] Process complete: Income saved (ID: ${income._id})`);
    res.status(201).json(income);
  } catch (error) {
    console.error(`💥 [Income] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.deleteIncome = async (req, res) => {
  const id = req.params.id;
  console.log(`⚙️ [Income] Process started: Deleting income record ${id}...`);
  try {
    console.log(`💾 [Income] Database operation: Removing record...`);
    const income = await Income.findOneAndDelete({ _id: id, companyId: req.user.companyId });
    if (!income) {
      console.log(`❌ [Income] Process halted: Income record ${id} not found`);
      return res.status(404).json({ message: 'Income not found' });
    }
    console.log(`✨ [Income] Process complete: Income removed`);
    res.json({ message: 'Income deleted' });
  } catch (error) {
    console.error(`💥 [Income] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};
