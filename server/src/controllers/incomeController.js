const Income = require('../models/Income');

exports.getIncomes = async (req, res) => {
  try {
    const incomes = await Income.find({ companyId: req.user.companyId }).sort({ date: -1 });
    res.json(incomes);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.addIncome = async (req, res) => {
  try {
    const incomeData = { ...req.body };
    delete incomeData._id;

    const income = await Income.create({
      ...incomeData,
      companyId: req.user.companyId
    });
    res.status(201).json(income);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.deleteIncome = async (req, res) => {
  try {
    const income = await Income.findOneAndDelete({ _id: req.params.id, companyId: req.user.companyId });
    if (!income) return res.status(404).json({ message: 'Income not found' });
    res.json({ message: 'Income deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
