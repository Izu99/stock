const StockItem = require('../models/StockItem');
const Sale = require('../models/Sale');
const Expense = require('../models/Expense');
const Income = require('../models/Income');

exports.getSummary = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);

    // Filter by companyId
    const filter = { companyId: req.user.companyId };

    // Total Stock Value
    const stockItems = await StockItem.find(filter);
    const totalStockValue = stockItems.reduce((acc, item) => {
      const val = (item.buyPrice || 0) * (item.quantity || 0);
      return acc + (isNaN(val) ? 0 : val);
    }, 0);

    // Today's Sales
    const todaySalesData = await Sale.find({ ...filter, date: { $gte: today } });
    const todaySales = todaySalesData.reduce((acc, sale) => acc + (sale.subtotal || 0), 0);

    // Monthly Sales
    const monthlySalesData = await Sale.find({ ...filter, date: { $gte: monthStart } });
    const monthlySales = monthlySalesData.reduce((acc, sale) => acc + (sale.subtotal || 0), 0);

    // Total Expenses (Monthly)
    const expenseData = await Expense.find({ ...filter, date: { $gte: monthStart } });
    const totalExpenses = expenseData.reduce((acc, exp) => acc + (exp.amount || 0), 0);

    // Other Income (Monthly)
    const incomeData = await Income.find({ ...filter, date: { $gte: monthStart } });
    const otherIncome = incomeData.reduce((acc, inc) => acc + (inc.amount || 0), 0);

    // Profit (from sales)
    const salesProfit = monthlySalesData.reduce((acc, sale) => acc + (sale.profit || 0), 0);
    
    // Net Profit = (Sales Profit + Other Income) - Expenses
    const netProfit = (salesProfit + otherIncome) - totalExpenses;

    res.json({
      totalStockValue,
      todaySales,
      monthlySales,
      totalExpenses,
      otherIncome,
      profit: netProfit,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
