const { body, param, query, validationResult } = require('express-validator');
const { ValidationError } = require('../utils/errors');

// Validation result handler
const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const errorMessages = errors.array().map(err => err.msg).join(', ');
    throw new ValidationError(errorMessages);
  }
  next();
};

// Auth validators
const registerValidator = [
  body('username').trim().notEmpty().withMessage('Username is required')
    .isLength({ min: 3 }).withMessage('Username must be at least 3 characters'),
  body('email').trim().isEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  body('role').optional().isIn(['company']).withMessage('Invalid role'),
  validate
];

const loginValidator = [
  body('email').trim().isEmail().withMessage('Valid email is required'),
  body('password').notEmpty().withMessage('Password is required'),
  validate
];

// Stock validators
const createStockValidator = [
  body('name').trim().notEmpty().withMessage('Item name is required'),
  body('category').trim().notEmpty().withMessage('Category is required'),
  body('quantity').isInt({ min: 0 }).withMessage('Quantity must be a positive number'),
  body('unit').trim().notEmpty().withMessage('Unit is required'),
  body('purchasePrice').isFloat({ min: 0 }).withMessage('Purchase price must be a positive number'),
  body('sellingPrice').isFloat({ min: 0 }).withMessage('Selling price must be a positive number'),
  body('minimumLevel').optional().isInt({ min: 0 }).withMessage('Minimum level must be a positive number'),
  body('barcode').optional().trim(),
  validate
];

const updateStockValidator = [
  param('id').isMongoId().withMessage('Invalid stock item ID'),
  body('name').optional().trim().notEmpty().withMessage('Item name cannot be empty'),
  body('category').optional().trim().notEmpty().withMessage('Category cannot be empty'),
  body('quantity').optional().isInt({ min: 0 }).withMessage('Quantity must be a positive number'),
  body('unit').optional().trim().notEmpty().withMessage('Unit cannot be empty'),
  body('purchasePrice').optional().isFloat({ min: 0 }).withMessage('Purchase price must be a positive number'),
  body('sellingPrice').optional().isFloat({ min: 0 }).withMessage('Selling price must be a positive number'),
  body('minimumLevel').optional().isInt({ min: 0 }).withMessage('Minimum level must be a positive number'),
  validate
];

// Sale validators
const createSaleValidator = [
  body('items').isArray({ min: 1 }).withMessage('At least one item is required'),
  body('items.*.stockItemId').isMongoId().withMessage('Invalid stock item ID'),
  body('items.*.quantity').isInt({ min: 1 }).withMessage('Quantity must be at least 1'),
  body('items.*.sellingPrice').isFloat({ min: 0 }).withMessage('Selling price must be positive'),
  body('totalAmount').isFloat({ min: 0 }).withMessage('Total amount must be positive'),
  body('paymentMethod').isIn(['cash', 'card', 'mobile', 'credit']).withMessage('Invalid payment method'),
  body('customerName').optional().trim(),
  body('customerPhone').optional().trim(),
  validate
];

// Expense validators
const createExpenseValidator = [
  body('description').trim().notEmpty().withMessage('Description is required'),
  body('amount').isFloat({ min: 0 }).withMessage('Amount must be a positive number'),
  body('category').trim().notEmpty().withMessage('Category is required'),
  body('date').optional().isISO8601().withMessage('Invalid date format'),
  validate
];

// Income validators
const createIncomeValidator = [
  body('description').trim().notEmpty().withMessage('Description is required'),
  body('amount').isFloat({ min: 0 }).withMessage('Amount must be a positive number'),
  body('source').trim().notEmpty().withMessage('Source is required'),
  body('date').optional().isISO8601().withMessage('Invalid date format'),
  validate
];

// ID validator
const idValidator = [
  param('id').isMongoId().withMessage('Invalid ID format'),
  validate
];

// Date range validator
const dateRangeValidator = [
  query('startDate').optional().isISO8601().withMessage('Invalid start date format'),
  query('endDate').optional().isISO8601().withMessage('Invalid end date format'),
  validate
];

module.exports = {
  validate,
  registerValidator,
  loginValidator,
  createStockValidator,
  updateStockValidator,
  createSaleValidator,
  createExpenseValidator,
  createIncomeValidator,
  idValidator,
  dateRangeValidator
};
