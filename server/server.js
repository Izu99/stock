const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const morgan = require('morgan');
const connectDB = require('./src/config/db');

dotenv.config();

const startServer = async () => {
  await connectDB();

  const app = express();

  app.use(express.json());
  app.use(cors());
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

  app.get('/', (req, res) => {
    res.send('API is running...');
  });

  const PORT = process.env.PORT || 5000;

  app.listen(PORT, () => {
    console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
  });
};

startServer();