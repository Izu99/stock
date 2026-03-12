const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const morgan = require('morgan');
const connectDB = require('./src/config/db');
const logger = require('./src/utils/logger');
const { errorHandler } = require('./src/middleware/errorHandler');
const { NotFoundError } = require('./src/utils/errors');

dotenv.config();

const startServer = async () => {
  await connectDB();

  const app = express();

  app.use(express.json());
  app.use(cors());
  
  // Detailed Request Logging
  const detailedLogger = require('./src/middleware/loggerMiddleware');
  app.use(detailedLogger);

  if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
  }

  // Routes
  app.use('/api/auth', require('./src/routes/authRoutes'));
  app.use('/api/dashboard', require('./src/routes/dashboardRoutes'));
  app.use('/api/stock', require('./src/routes/stockRoutes'));
  app.use('/api/sales', require('./src/routes/saleRoutes'));
  app.use('/api/expenses', require('./src/routes/expenseRoutes'));
  app.use('/api/income', require('./src/routes/incomeRoutes'));
  app.use('/api/companies', require('./src/routes/companyRoutes'));
  app.use('/api/stock-movements', require('./src/routes/stockMovementRoutes'));
  app.use('/api/analytics', require('./src/routes/analyticsRoutes'));
  app.use('/api/categories', require('./src/routes/categoryRoutes'));

  app.get('/', (req, res) => {
    res.send('API is running...');
  });

  // 404 handler for unknown routes
  app.use((req, res, next) => {
    next(new NotFoundError(`Route not found - ${req.originalUrl}`));
  });

  // Global error handler (must be last)
  app.use(errorHandler);

  const PORT = process.env.PORT || 5000;

  app.listen(PORT, () => {
    logger.info(`🚀 SERVER VERSION: SECURE_ROLES_V1`);
    logger.info(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
  });
};

startServer();