const StockItem = require('../models/StockItem');
const Sale = require('../models/Sale');
const Expense = require('../models/Expense');
const Income = require('../models/Income');

exports.getSummary = async (req, res) => {
  const { startDate, endDate } = req.query;
  console.log(`⚙️ [Dashboard] Process started: Calculating summary for company ${req.user.companyId}...`);
  try {
    const filter = { companyId: req.user.companyId };
    let dateFilter = {};

    if (startDate && endDate) {
      dateFilter = { 
        date: { 
          $gte: new Date(startDate), 
          $lte: new Date(endDate) 
        } 
      };
    }

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);

    console.log(`🔍 [Dashboard] Database check: Aggregating stock items...`);
    const stockItems = await StockItem.find(filter);
    const totalStockValue = stockItems.reduce((acc, item) => acc + ((item.buyPrice || 0) * (item.quantity || 0)), 0);

    // If custom range, use it for stats, otherwise use defaults
    const salesRange = startDate ? dateFilter : { date: { $gte: monthStart } };
    const todaySalesRange = { date: { $gte: today } };

    console.log(`🔍 [Dashboard] Database check: Aggregating sales...`);
    const rangeSalesData = await Sale.find({ ...filter, ...salesRange });
    const totalSalesInRange = rangeSalesData.reduce((acc, sale) => acc + (sale.totalAmount || sale.subtotal || 0), 0);
    
    const todaySalesData = await Sale.find({ ...filter, ...todaySalesRange });
    const todaySales = todaySalesData.reduce((acc, sale) => acc + (sale.totalAmount || sale.subtotal || 0), 0);

    const monthlySalesData = await Sale.find({ ...filter, date: { $gte: monthStart } });
    const monthlySales = monthlySalesData.reduce((acc, sale) => acc + (sale.totalAmount || sale.subtotal || 0), 0);



    console.log(`🔍 [Dashboard] Database check: Aggregating expenses and other income...`);
    const expenseRange = startDate ? dateFilter : { date: { $gte: monthStart } };
    const expenseData = await Expense.find({ ...filter, ...expenseRange });
    const totalExpenses = expenseData.reduce((acc, exp) => acc + (exp.amount || 0), 0);

    const incomeRange = startDate ? dateFilter : { date: { $gte: monthStart } };
    const incomeData = await Income.find({ ...filter, ...incomeRange });
    const otherIncome = incomeData.reduce((acc, inc) => acc + (inc.amount || 0), 0);

    console.log(`💰 [Dashboard] Calculation: Computing net profit...`);
    const salesProfit = rangeSalesData.reduce((acc, sale) => acc + (sale.totalProfit || sale.profit || 0), 0);
    const netProfit = (salesProfit + otherIncome) - totalExpenses;
 military:


    console.log(`🔍 [Dashboard] Database check: Fetching recent activity...`);

    const recentSales = await Sale.find(filter).sort({ date: -1 }).limit(50);
    const recentExpenses = await Expense.find(filter).sort({ date: -1 }).limit(50);

    // If date range provided, filter all transactions for export
    let allTransactions = [];
    if (startDate) {
      const filteredSales = await Sale.find({ ...filter, ...dateFilter }).sort({ date: -1 });
      const filteredExpenses = await Expense.find({ ...filter, ...dateFilter }).sort({ date: -1 });
      const filteredIncome = await Income.find({ ...filter, ...dateFilter }).sort({ date: -1 });

      allTransactions = [
        ...filteredSales.map(s => {
          // Robust item list construction for legacy data support
          const items = s.items && s.items.length > 0 
            ? s.items.map(item => ({
                name: item.itemName,
                qty: item.quantity,
                price: item.sellPrice,
                total: item.subtotal,
                profit: item.profit
              }))
            : [{
                name: s.itemName || 'Unknown Item',
                qty: s.quantity || 0,
                price: s.sellPrice || 0,
                total: s.subtotal || 0,
                profit: s.profit || 0
              }];

          return {
            id: s._id,
            title: s.billId ? `Bill #${s.billId.split('-').pop()}` : (s.itemName || 'Sale'),
            amount: s.totalAmount || s.subtotal || 0,
            date: s.date,
            type: 'sale',
            items: items
          };
        }),

        ...filteredExpenses.map(e => ({ id: e._id, title: e.title, amount: e.amount, date: e.date, type: 'expense' })),
        ...filteredIncome.map(i => ({ id: i._id, title: i.title || 'Other Income', amount: i.amount, date: i.date, type: 'income' }))
      ].sort((a, b) => new Date(b.date) - new Date(a.date));
    }


    const recentTransactions = [
      ...recentSales.map(s => ({ 
        id: s._id, 
        title: s.items && s.items.length > 1 
          ? `Bill #${s.billId}` 
          : (s.itemName || (s.items && s.items[0]?.itemName) || 'Sale'), 
        amount: s.totalAmount || s.subtotal || 0, 
        date: s.date, 
        type: 'sale' 
      })),

      ...recentExpenses.map(e => ({ id: e._id, title: e.title, amount: e.amount, date: e.date, type: 'expense' }))
    ].sort((a, b) => new Date(b.date) - new Date(a.date)).slice(0, 5);


    // --- NEW: Detailed Analytics for Reports ---
    console.log(`🔍 [Dashboard] Database check: Generating trend analytics...`);
    
    // 1. Sales History (Daily vs Monthly)
    const end = endDate ? new Date(endDate) : new Date();
    const start = startDate ? new Date(startDate) : new Date();
    const diffDays = Math.abs((end - start) / (1000 * 60 * 60 * 24));
    
    let historyData;
    if (diffDays > 25) {
      // MONTHLY VIEW: show month-by-month for the last 6 months
      const sixMonthsAgo = new Date(end);
      sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 5);
      sixMonthsAgo.setDate(1);
      
      historyData = await Sale.aggregate([
        { $match: { companyId: req.user.companyId, date: { $gte: sixMonthsAgo, $lte: end } } },
        {
          $group: {
            _id: { $dateToString: { format: "%Y-%m-01", date: "$date" } },
            total: { $sum: { $ifNull: ["$totalAmount", "$subtotal"] } },
            profit: { $sum: { $ifNull: ["$totalProfit", "$profit"] } },
            count: { $sum: 1 }
          }

        },
        { $sort: { "_id": 1 } }
      ]);
    } else {
      // DAILY VIEW: show last 30 days daily
      const thirtyDaysAgo = new Date(end);
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      
      historyData = await Sale.aggregate([
        { $match: { companyId: req.user.companyId, date: { $gte: thirtyDaysAgo, $lte: end } } },
        {
          $group: {
            _id: { $dateToString: { format: "%Y-%m-%d", date: "$date" } },
            total: { $sum: { $ifNull: ["$totalAmount", "$subtotal"] } },
            profit: { $sum: { $ifNull: ["$totalProfit", "$profit"] } },
            count: { $sum: 1 }
          }

        },
        { $sort: { "_id": 1 } }
      ]);

    }

    // 2. Expense Category Breakdown
    const expenseBreakdown = await Expense.aggregate([
      { $match: { companyId: req.user.companyId, ...expenseRange } },
      {
        $group: {
          _id: "$category",
          amount: { $sum: "$amount" }
        }
      }
    ]);

    // 3. Top Selling Items
    const topItems = await Sale.aggregate([
      { $match: { companyId: req.user.companyId, ...salesRange } },
      // Project to unify layout before unwind
      {
        $project: {
          items: {
            $cond: {
              if: { $and: [{ $isArray: "$items" }, { $gt: [{ $size: "$items" }, 0] }] },
              then: "$items",
              else: [{
                itemName: "$itemName",
                subtotal: "$subtotal",
                quantity: "$quantity"
              }]
            }
          }
        }
      },
      { $unwind: "$items" },
      {
        $group: {
          _id: "$items.itemName",
          totalSales: { $sum: "$items.subtotal" },
          quantity: { $sum: "$items.quantity" }
        }
      },

      { $sort: { totalSales: -1 } },
      { $limit: 5 }
    ]);


    console.log(`✨ [Dashboard] Process complete: Summary data generated successfully`);
    res.json({
      totalStockValue,
      todaySales,
      monthlySales,
      totalExpenses,
      otherIncome,
      profit: netProfit,
      recentTransactions,
      allTransactions: allTransactions.length > 0 ? allTransactions : undefined,
      rangeStats: startDate ? {
        sales: totalSalesInRange,
        expenses: totalExpenses,
        income: otherIncome,
        profit: netProfit
      } : undefined,
      salesHistory: historyData.map(h => ({ date: h._id, amount: h.total, profit: h.profit })),
      expenseBreakdown: expenseBreakdown.map(e => ({ category: e._id, amount: e.amount })),
      topItems: topItems.map(t => ({ name: t._id, total: t.totalSales, qty: t.quantity }))
    });
  } catch (error) {
    console.error(`💥 [Dashboard] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};
