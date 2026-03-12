const Company = require('../models/Company');
const User = require('../models/User');

// @desc    Check if a value is already in use
exports.checkAvailability = async (req, res) => {
  const { type, value } = req.query;
  console.log(`⚙️ [Company] Process started: Checking availability for ${type} (${value})...`);
  try {
    if (!type || !value) return res.status(400).json({ message: 'Type and value are required' });

    let exists = false;
    console.log(`🔍 [Company] Database check: Scanning ${type} field...`);
    switch (type) {
      case 'companyPhone':
        exists = await Company.exists({ phone: value });
        break;
      case 'ownerEmail':
        exists = await Company.exists({ 'owner.email': value });
        break;
      case 'username':
        exists = await User.exists({ username: value.toLowerCase() });
        break;
      case 'ownerPhone':
        exists = await User.exists({ phone: value });
        break;
    }

    console.log(`✨ [Company] Process complete: Available = ${!exists}`);
    res.json({ available: !exists });
  } catch (error) {
    console.error(`💥 [Company] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

// @desc    Register a new company
exports.registerCompany = async (req, res) => {
  console.log('📥 [FRONTEND DATA RECEIVED]:', JSON.stringify(req.body, null, 2));
  
  const { name, phone, address, owner, password, role } = req.body;
  const username = req.body.username ? req.body.username.toLowerCase() : null;
  
  if (role) {
    console.log(`⚠️ [SECURITY NOTICE]: Frontend tried to send role: "${role}"`);
  }

  console.log(`⚙️ [Company] Process started: Registering company ${name}...`);
  try {
    if (!username) {
      console.log(`⚠️ [Company] Process halted: Missing username`);
      return res.status(400).json({ message: 'Username is required' });
    }

    console.log(`🔍 [Company] Database check: Verifying constraints (phone, email, username)...`);
    const companyPhoneExists = await Company.findOne({ phone });
    if (companyPhoneExists) {
      console.log(`⚠️ [Company] Process halted: Duplicate company phone`);
      return res.status(400).json({ message: 'This company phone number is already registered' });
    }

    const emailExists = await User.findOne({ email: owner.email });
    if (emailExists) {
      console.log(`⚠️ [Company] Process halted: Duplicate owner email`);
      return res.status(400).json({ message: 'This owner email is already in use' });
    }

    const usernameExists = await User.findOne({ username });
    if (usernameExists) {
      console.log(`⚠️ [Company] Process halted: Duplicate username`);
      return res.status(400).json({ message: 'This username is already taken' });
    }

    console.log(`💾 [Company] Database operation: Creating company record...`);
    const company = await Company.create({ name, phone, address, owner });

    const ASSIGNED_ROLE = 'company';
    console.log(`🛠️ [BACKEND LOGIC]: Forcing role to: "${ASSIGNED_ROLE}" (Ignoring any frontend input)`);
    
    try {
      const newUser = await User.create({
        username,
        email: owner.email,
        phone: owner.phone,
        password, 
        role: ASSIGNED_ROLE,
        companyId: company._id
      });
      console.log(`🎯 [DATABASE FINAL]: User created with role in memory: "${newUser.role}"`);
    } catch (userError) {
      console.log(`🚨 [Company] ROLLBACK: User creation failed, deleting company ${company._id}`);
      await Company.findByIdAndDelete(company._id);
      throw userError;
    }

    console.log(`✨ [Company] Process complete: ${name} registered successfully`);
    res.status(201).json(company);
  } catch (error) {
    console.error(`💥 [Company] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.getCompanies = async (req, res) => {
  console.log(`⚙️ [Company] Process started: Fetching all companies...`);
  try {
    const companies = await Company.find({}).sort({ createdAt: -1 });
    console.log(`✨ [Company] Process complete: Found ${companies.length} companies`);
    res.json(companies);
  } catch (error) {
    console.error(`💥 [Company] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

exports.getCompanySummary = async (req, res) => {
  console.log(`⚙️ [Company] Process started: Calculating company summary...`);
  try {
    const totalCompanies = await Company.countDocuments();
    const activeCompanies = await Company.countDocuments({ isActive: true });
    const inactiveCompanies = totalCompanies - activeCompanies;

    console.log(`✨ [Company] Process complete: Summary generated`);
    res.json({ totalCompanies, activeCompanies, inactiveCompanies });
  } catch (error) {
    console.error(`💥 [Company] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

exports.updateCompanyStatus = async (req, res) => {
  const id = req.params.id;
  console.log(`⚙️ [Company] Process started: Updating status for company ${id}...`);
  try {
    const company = await Company.findById(id);
    if (!company) {
      console.log(`❌ [Company] Process halted: Company ${id} not found`);
      return res.status(404).json({ message: 'Company not found' });
    }

    company.isActive = req.body.isActive !== undefined ? req.body.isActive : !company.isActive;
    await company.save();
    console.log(`✨ [Company] Process complete: Status updated to ${company.isActive}`);
    res.json(company);
  } catch (error) {
    console.error(`💥 [Company] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.updateCompany = async (req, res) => {
  const id = req.params.id;
  const { name, phone, address, owner } = req.body;
  console.log(`⚙️ [Company] Process started: Updating details for company ${id}...`);
  try {
    const company = await Company.findById(id);
    if (!company) {
      console.log(`❌ [Company] Process halted: Company ${id} not found`);
      return res.status(404).json({ message: 'Company not found' });
    }

    if (phone && phone !== company.phone) {
      console.log(`🔍 [Company] Database check: Verifying new phone availability...`);
      const phoneExists = await Company.findOne({ phone, _id: { $ne: id } });
      if (phoneExists) return res.status(400).json({ message: 'Another company is already using this phone number' });
    }

    if (owner && owner.email && owner.email !== company.owner.email) {
      console.log(`🔍 [Company] Database check: Verifying new owner email...`);
      const emailExists = await Company.findOne({ 'owner.email': owner.email, _id: { $ne: id } });
      if (emailExists) return res.status(400).json({ message: 'Owner email already registered' });
    }

    company.name = name || company.name;
    company.phone = phone || company.phone;
    company.address = address || company.address;
    
    if (owner) {
      company.owner = { ...company.owner, ...owner };
      console.log(`💾 [Company] Database operation: Syncing owner email to company user...`);
      await User.findOneAndUpdate({ companyId: company._id, role: 'company' }, { email: company.owner.email, phone: company.owner.phone });
    }

    await company.save();
    console.log(`✨ [Company] Process complete: Company ${id} updated`);
    res.json(company);
  } catch (error) {
    console.error(`💥 [Company] Process failed: ${error.message}`);
    res.status(400).json({ message: error.message });
  }
};

exports.deleteCompany = async (req, res) => {
  const id = req.params.id;
  console.log(`⚙️ [Company] Process started: Deleting company ${id}...`);
  try {
    const company = await Company.findByIdAndDelete(id);
    if (!company) {
      console.log(`❌ [Company] Process halted: Company ${id} not found`);
      return res.status(404).json({ message: 'Company not found' });
    }
    console.log(`💾 [Company] Database operation: Deleting all users associated with company ${id}...`);
    await User.deleteMany({ companyId: id });
    
    console.log(`✨ [Company] Process complete: ${id} and associated users removed`);
    res.json({ message: 'Company deleted' });
  } catch (error) {
    console.error(`💥 [Company] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};
