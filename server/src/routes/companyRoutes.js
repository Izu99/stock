const express = require('express');
const router = express.Router();
const {
  registerCompany,
  getCompanies,
  getCompanySummary,
  updateCompanyStatus,
  updateCompany,
  deleteCompany,
  checkAvailability
} = require('../controllers/companyController');
const { protect } = require('../middleware/authMiddleware');

router.get('/check-availability', protect, checkAvailability);

router.route('/')
  .get(protect, getCompanies)
  .post(protect, registerCompany);

router.get('/summary', protect, getCompanySummary);

router.route('/:id/status')
  .patch(protect, updateCompanyStatus);

router.route('/:id')
  .put(protect, updateCompany)
  .delete(protect, deleteCompany);

module.exports = router;
