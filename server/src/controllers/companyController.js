const Company = require('../models/Company');
const User = require('../models/User');

// @desc    Register a new company and create admin user
// @route   POST /api/companies
// @access  Private/SuperAdmin
exports.registerCompany = async (req, res) => {
  try {
    const companyData = { ...req.body };
    const { name, phone, address, owner, password } = req.body;
    const username = req.body.username.toLowerCase();
    
    // The original code had these deletes, but with direct destructuring from req.body
    // for company fields and username/password, these might be less relevant for companyData
    // if companyData is only used for the company creation itself.
    // However, to maintain the original flow where companyData was the source for company fields,
    // we'll keep it consistent with the original intent of companyData holding the company-specific fields.
    // The username and password are now explicitly handled.
    delete companyData._id;
    delete companyData.username; // Ensure username is not passed to companyData if it's not a company field
    delete companyData.password; // Ensure password is not passed to companyData

    // Check if user exists
    const userExists = await User.findOne({ 
      $or: [{ username }, { email: owner.email }] 
    });

    if (userExists) {
      return res.status(400).json({ message: 'Username or email already exists' });
    }

    // Create Company
    const company = await Company.create({
      name,
      phone,
      address,
      owner
    });

    // Create Admin User for the Company
    await User.create({
      username,
      email: owner.email,
      password, // Password hashing is handled by User model pre-save hook
      role: 'admin',
      companyId: company._id
    });

    res.status(201).json(company);
  } catch (error) {
    // If user creation fails, we might want to delete the company? 
    // For simplicity, we'll just error out. Ideally use transactions.
    res.status(400).json({ message: error.message });
  }
};

// @desc    Get all companies
// @route   GET /api/companies
// @access  Private/SuperAdmin
exports.getCompanies = async (req, res) => {
  try {
    const companies = await Company.find({}).sort({ createdAt: -1 });
    res.json(companies);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get company summary for dashboard
// @route   GET /api/companies/summary
// @access  Private/SuperAdmin
exports.getCompanySummary = async (req, res) => {
  try {
    const totalCompanies = await Company.countDocuments();
    const activeCompanies = await Company.countDocuments({ isActive: true });
    const inactiveCompanies = totalCompanies - activeCompanies;

    res.json({
      totalCompanies,
      activeCompanies,
      inactiveCompanies,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update company status
// @route   PATCH /api/companies/:id/status
// @access  Private/SuperAdmin
exports.updateCompanyStatus = async (req, res) => {
  try {
    const company = await Company.findById(req.params.id);
    if (!company) return res.status(404).json({ message: 'Company not found' });

    company.isActive = req.body.isActive !== undefined ? req.body.isActive : !company.isActive;
    await company.save();
    res.json(company);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// @desc    Delete company
// @route   DELETE /api/companies/:id
// @access  Private/SuperAdmin
exports.deleteCompany = async (req, res) => {
  try {
    const company = await Company.findByIdAndDelete(req.params.id);
    if (!company) return res.status(404).json({ message: 'Company not found' });
    res.json({ message: 'Company deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
