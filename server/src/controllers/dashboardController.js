const StockItem = require('../models/StockItem');
const Sale = require('../models/Sale');
const Expense = require('../models/Expense');
const Income = require('../models/Income');

exports.getSummary = async (req, res) => {
  console.log(`⚙️ [Dashboard] Process started: Calculating summary for company ${req.user.companyId}...`);
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);

    const filter = { companyId: req.user.companyId };

    console.log(`🔍 [Dashboard] Database check: Aggregating stock items...`);
    const stockItems = await StockItem.find(filter);
    const totalStockValue = stockItems.reduce((acc, item) => acc + ((item.buyPrice || 0) * (item.quantity || 0)), 0);

    console.log(`🔍 [Dashboard] Database check: Aggregating sales (Today & Monthly)...`);
    const todaySalesData = await Sale.find({ ...filter, date: { $gte: today } });
    const todaySales = todaySalesData.reduce((acc, sale) => acc + (sale.subtotal || 0), 0);

    const monthlySalesData = await Sale.find({ ...filter, date: { $gte: monthStart } });
    const monthlySales = monthlySalesData.reduce((acc, sale) => acc + (sale.subtotal || 0), 0);

    console.log(`🔍 [Dashboard] Database check: Aggregating expenses and other income...`);
    const expenseData = await Expense.find({ ...filter, date: { $gte: monthStart } });
    const totalExpenses = expenseData.reduce((acc, exp) => acc + (exp.amount || 0), 0);

    const incomeData = await Income.find({ ...filter, date: { $gte: monthStart } });
    const otherIncome = incomeData.reduce((acc, inc) => acc + (inc.amount || 0), 0);

    console.log(`💰 [Dashboard] Calculation: Computing net profit...`);
    const salesProfit = monthlySalesData.reduce((acc, sale) => acc + (sale.profit || 0), 0);
    const netProfit = (salesProfit + otherIncome) - totalExpenses;

    console.log(`🔍 [Dashboard] Database check: Fetching recent activity...`);
    const recentSales = await Sale.find(filter).sort({ date: -1 }).limit(5);
    const recentExpenses = await Expense.find(filter).sort({ date: -1 }).limit(5);

    const recentTransactions = [
      ...recentSales.map(s => ({ id: s._id, title: s.itemName, amount: s.subtotal, date: s.date, type: 'sale' })),
      ...recentExpenses.map(e => ({ id: e._id, title: e.title, amount: e.amount, date: e.date, type: 'expense' }))
    ].sort((a, b) => b.date - a.date).slice(0, 5);

    console.log(`✨ [Dashboard] Process complete: Summary data generated successfully`);
    res.json({
      totalStockValue,
      todaySales,
      monthlySales,
      totalExpenses,
      otherIncome,
      profit: netProfit,
      recentTransactions,
    });
  } catch (error) {
    console.error(`💥 [Dashboard] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};
