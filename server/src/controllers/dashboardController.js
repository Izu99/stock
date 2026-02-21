const StockItem = require('../models/StockItem');
const Sale = require('../models/Sale');
const Expense = require('../models/Expense');
const Income = require('../models/Income');

exports.getSummary = async (req, res) => {
  console.log(`📊 [DashboardController] getSummary called - companyId: ${req.user.companyId}`);
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

    // Recent Transactions (Last 5)
    const recentSales = await Sale.find(filter).sort({ date: -1 }).limit(5);
    const recentExpenses = await Expense.find(filter).sort({ date: -1 }).limit(5);

    const recentTransactions = [
      ...recentSales.map(s => ({
        id: s._id,
        title: s.itemName,
        amount: s.subtotal,
        date: s.date,
        type: 'sale'
      })),
      ...recentExpenses.map(e => ({
        id: e._id,
        title: e.title,
        amount: e.amount,
        date: e.date,
        type: 'expense'
      }))
    ].sort((a, b) => b.date - a.date).slice(0, 5);

    console.log(`✅ [DashboardController] Summary: stockValue=${totalStockValue}, todaySales=${todaySales}, monthlySales=${monthlySales}, expenses=${totalExpenses}, profit=${netProfit}, recentTx=${recentTransactions.length}`);

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
    console.error(`❌ [DashboardController] Error:`, error.message, error.stack);
    res.status(500).json({ message: error.message });
  }
};
