const Sale = require('../models/Sale');
const StockItem = require('../models/StockItem');
const Expense = require('../models/Expense');
const Income = require('../models/Income');
const { asyncHandler } = require('../middleware/errorHandler');
const logger = require('../utils/logger');

// Get profitability per item
exports.getItemProfitability = asyncHandler(async (req, res) => {
  const { startDate, endDate } = req.query;

  const dateFilter = {};
  if (startDate) dateFilter.$gte = new Date(startDate);
  if (endDate) dateFilter.$lte = new Date(endDate);

  const sales = await Sale.find({
    companyId: req.user.companyId,
    ...(Object.keys(dateFilter).length > 0 && { date: dateFilter })
  }).populate('items.stockItemId');

  // Calculate profit per item
  const itemProfits = {};

  sales.forEach(sale => {
    sale.items.forEach(item => {
      const stockItem = item.stockItemId;
      if (!stockItem) return;

      const itemId = stockItem._id.toString();
      const profit = (item.sellingPrice - stockItem.buyPrice) * item.quantity;
      const revenue = item.sellingPrice * item.quantity;

      if (!itemProfits[itemId]) {
        itemProfits[itemId] = {
          itemId,
          name: stockItem.name,
          category: stockItem.category,
          totalRevenue: 0,
          totalProfit: 0,
          totalQuantitySold: 0,
          salesCount: 0
        };
      }

      itemProfits[itemId].totalRevenue += revenue;
      itemProfits[itemId].totalProfit += profit;
      itemProfits[itemId].totalQuantitySold += item.quantity;
      itemProfits[itemId].salesCount += 1;
    });
  });

  // Convert to array and sort by profit
  const profitabilityData = Object.values(itemProfits)
    .map(item => ({
      ...item,
      profitMargin: item.totalRevenue > 0 ? (item.totalProfit / item.totalRevenue) * 100 : 0
    }))
    .sort((a, b) => b.totalProfit - a.totalProfit);

  res.json({ success: true, data: profitabilityData });
});

// Get profitability per category
exports.getCategoryProfitability = asyncHandler(async (req, res) => {
  const { startDate, endDate } = req.query;

  const dateFilter = {};
  if (startDate) dateFilter.$gte = new Date(startDate);
  if (endDate) dateFilter.$lte = new Date(endDate);

  const sales = await Sale.find({
    companyId: req.user.companyId,
    ...(Object.keys(dateFilter).length > 0 && { date: dateFilter })
  }).populate('items.stockItemId');

  const categoryProfits = {};

  sales.forEach(sale => {
    sale.items.forEach(item => {
      const stockItem = item.stockItemId;
      if (!stockItem) return;

      const category = stockItem.category;
      const profit = (item.sellingPrice - stockItem.buyPrice) * item.quantity;
      const revenue = item.sellingPrice * item.quantity;

      if (!categoryProfits[category]) {
        categoryProfits[category] = {
          category,
          totalRevenue: 0,
          totalProfit: 0,
          totalQuantitySold: 0,
          itemCount: new Set()
        };
      }

      categoryProfits[category].totalRevenue += revenue;
      categoryProfits[category].totalProfit += profit;
      categoryProfits[category].totalQuantitySold += item.quantity;
      categoryProfits[category].itemCount.add(stockItem._id.toString());
    });
  });

  const profitabilityData = Object.values(categoryProfits)
    .map(cat => ({
      category: cat.category,
      totalRevenue: cat.totalRevenue,
      totalProfit: cat.totalProfit,
      totalQuantitySold: cat.totalQuantitySold,
      uniqueItems: cat.itemCount.size,
      profitMargin: cat.totalRevenue > 0 ? (cat.totalProfit / cat.totalRevenue) * 100 : 0
    }))
    .sort((a, b) => b.totalProfit - a.totalProfit);

  res.json({ success: true, data: profitabilityData });
});

// Cash flow forecast
exports.getCashFlowForecast = asyncHandler(async (req, res) => {
  const { days = 30 } = req.query;

  // Get historical data for the last 30 days
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  const [sales, expenses, income] = await Promise.all([
    Sale.find({
      companyId: req.user.companyId,
      date: { $gte: thirtyDaysAgo }
    }),
    Expense.find({
      companyId: req.user.companyId,
      date: { $gte: thirtyDaysAgo }
    }),
    Income.find({
      companyId: req.user.companyId,
      date: { $gte: thirtyDaysAgo }
    })
  ]);

  // Calculate averages
  const avgDailyRevenue = sales.reduce((sum, s) => sum + s.totalAmount, 0) / 30;
  const avgDailyExpenses = expenses.reduce((sum, e) => sum + e.amount, 0) / 30;
  const avgDailyIncome = income.reduce((sum, i) => sum + i.amount, 0) / 30;
  const avgDailyProfit = avgDailyRevenue + avgDailyIncome - avgDailyExpenses;

  // Get current cash (simplified - you might want to track this separately)
  const totalRevenue = sales.reduce((sum, s) => sum + s.totalAmount, 0);
  const totalExpenses = expenses.reduce((sum, e) => sum + e.amount, 0);
  const totalIncome = income.reduce((sum, i) => sum + i.amount, 0);
  const currentCash = totalRevenue + totalIncome - totalExpenses;

  // Forecast
  const forecast = [];
  let projectedCash = currentCash;

  for (let i = 1; i <= parseInt(days); i++) {
    projectedCash += avgDailyProfit;
    const forecastDate = new Date();
    forecastDate.setDate(forecastDate.getDate() + i);

    forecast.push({
      date: forecastDate,
      projectedCash: Math.round(projectedCash * 100) / 100,
      projectedRevenue: Math.round(avgDailyRevenue * 100) / 100,
      projectedExpenses: Math.round(avgDailyExpenses * 100) / 100
    });
  }

  res.json({
    success: true,
    data: {
      currentCash: Math.round(currentCash * 100) / 100,
      avgDailyRevenue: Math.round(avgDailyRevenue * 100) / 100,
      avgDailyExpenses: Math.round(avgDailyExpenses * 100) / 100,
      avgDailyProfit: Math.round(avgDailyProfit * 100) / 100,
      forecast
    }
  });
});

// Inventory valuation
exports.getInventoryValuation = asyncHandler(async (req, res) => {
  const stockItems = await StockItem.find({
    companyId: req.user.companyId
  });

  let totalPurchaseValue = 0;
  let totalSellingValue = 0;
  const byCategory = {};

  stockItems.forEach(item => {
    const purchaseValue = item.buyPrice * item.quantity;
    const sellingValue = item.sellPrice * item.quantity;

    totalPurchaseValue += purchaseValue;
    totalSellingValue += sellingValue;

    if (!byCategory[item.category]) {
      byCategory[item.category] = {
        category: item.category,
        purchaseValue: 0,
        sellingValue: 0,
        itemCount: 0,
        totalQuantity: 0
      };
    }

    byCategory[item.category].purchaseValue += purchaseValue;
    byCategory[item.category].sellingValue += sellingValue;
    byCategory[item.category].itemCount += 1;
    byCategory[item.category].totalQuantity += item.quantity;
  });

  const potentialProfit = totalSellingValue - totalPurchaseValue;
  const profitMargin = totalSellingValue > 0 ? (potentialProfit / totalSellingValue) * 100 : 0;

  res.json({
    success: true,
    data: {
      totalPurchaseValue: Math.round(totalPurchaseValue * 100) / 100,
      totalSellingValue: Math.round(totalSellingValue * 100) / 100,
      potentialProfit: Math.round(potentialProfit * 100) / 100,
      profitMargin: Math.round(profitMargin * 100) / 100,
      totalItems: stockItems.length,
      byCategory: Object.values(byCategory)
    }
  });
});

// Top selling items
exports.getTopSellingItems = asyncHandler(async (req, res) => {
  const { limit = 5, startDate, endDate } = req.query;

  const dateFilter = {};
  if (startDate) dateFilter.$gte = new Date(startDate);
  if (endDate) dateFilter.$lte = new Date(endDate);

  const sales = await Sale.find({
    companyId: req.user.companyId,
    ...(Object.keys(dateFilter).length > 0 && { date: dateFilter })
  }).populate('items.stockItemId');

  const itemSales = {};

  sales.forEach(sale => {
    sale.items.forEach(item => {
      const stockItem = item.stockItemId;
      if (!stockItem) return;

      const itemId = stockItem._id.toString();

      if (!itemSales[itemId]) {
        itemSales[itemId] = {
          itemId,
          name: stockItem.name,
          category: stockItem.category,
          totalQuantity: 0,
          totalRevenue: 0,
          salesCount: 0
        };
      }

      itemSales[itemId].totalQuantity += item.quantity;
      itemSales[itemId].totalRevenue += item.sellingPrice * item.quantity;
      itemSales[itemId].salesCount += 1;
    });
  });

  const topItems = Object.values(itemSales)
    .sort((a, b) => b.totalQuantity - a.totalQuantity)
    .slice(0, parseInt(limit));

  res.json({ success: true, data: topItems });
});

// Items to reorder (low stock)
exports.getItemsToReorder = asyncHandler(async (req, res) => {
  const stockItems = await StockItem.find({
    companyId: req.user.companyId,
    $expr: { $lte: ['$quantity', '$minimumLevel'] }
  }).sort({ quantity: 1 });

  const reorderList = stockItems.map(item => ({
    id: item._id,
    name: item.name,
    category: item.category,
    currentQuantity: item.quantity,
    minimumLevel: item.minimumLevel,
    suggestedOrderQuantity: Math.max(item.minimumLevel * 2, 10),
    unit: item.unit,
    lastPurchasePrice: item.buyPrice
  }));

  res.json({ success: true, data: reorderList });
});

module.exports = exports;
