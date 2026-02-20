const express = require('express');
const router = express.Router();
const {
  registerCompany,
  getCompanies,
  getCompanySummary,
  updateCompanyStatus,
  deleteCompany
} = require('../controllers/companyController');
const { protect } = require('../middleware/authMiddleware');

router.route('/')
  .get(protect, getCompanies)
  .post(protect, registerCompany);

router.get('/summary', protect, getCompanySummary);

router.route('/:id/status')
  .patch(protect, updateCompanyStatus);

router.route('/:id')
  .delete(protect, deleteCompany);

module.exports = router;
