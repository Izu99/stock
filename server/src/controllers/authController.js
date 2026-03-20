const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });
};

exports.registerUser = async (req, res) => {
  console.log('📥 [AUTH FRONTEND DATA RECEIVED]:', JSON.stringify(req.body, null, 2));
  
  const { username, email, phone, password, role } = req.body;
  console.log(`⚙️ [Auth] Process started: Registering user ${username}...`);
  try {
    console.log(`🔍 [Auth] Database check: Looking for existing user...`);
    const userExists = await User.findOne({ 
      $or: [
        { email }, 
        { username },
        { phone }
      ] 
    });
    
    if (userExists) {
      console.log(`⚠️ [Auth] Process halted: User already exists`);
      return res.status(400).json({ message: 'User already exists (email, username or phone)' });
    }

    console.log(`💾 [Auth] Database operation: Creating user record...`);
    
    // SECURITY: Always force 'company' role. 'admin' is only for the super admin (you).
    const finalRole = 'company';
    console.log(`🛠️ [AUTH BACKEND LOGIC]: Forcing role to: "${finalRole}"`);

    const user = await User.create({ username, email, phone, password, role: finalRole });
    
    console.log(`✨ [Auth] Process complete: User created successfully. ID: ${user._id}, DB Role: "${user.role}"`);
    res.status(201).json({
      id: user._id,
      username: user.username,
      email: user.email,
      role: user.role,
      token: generateToken(user._id),
    });
  } catch (error) {
    console.error(`💥 [Auth] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

exports.loginUser = async (req, res) => {
  const { password } = req.body;
  const identifier = req.body.username.toLowerCase();
  
  console.log(`⚙️ [Auth] Process started: Login attempt for ${identifier}...`);
  try {
    console.log(`🔍 [Auth] Database check: Finding user by identifier...`);
    const user = await User.findOne({
      $or: [
        { username: identifier },
        { email: identifier },
        { phone: identifier }
      ]
    }).populate('companyId');
    
    if (!user) {
      console.log(`❌ [Auth] Process halted: User not found`);
      return res.status(401).json({ message: 'Invalid identifier or password' });
    }

    console.log(`🔑 [Auth] Security check: Matching password...`);
    const isMatch = await user.matchPassword(password);
    
    if (isMatch) {
      console.log(`✨ [Auth] Process complete: Login successful for ${user.username}`);
      res.json({
        id: user._id,
        username: user.username,
        email: user.email,
        role: user.role,
        company: user.companyId, // Return full company object
        token: generateToken(user._id),
      });
    } else {
      console.log(`❌ [Auth] Process halted: Incorrect password`);
      res.status(401).json({ message: 'Invalid username or password' });
    }
  } catch (error) {
    console.error(`💥 [Auth] Process failed: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};

exports.googleLogin = async (req, res) => {
  const { idToken } = req.body;
  console.log(`⚙️ [Auth] Google login attempt started...`);

  try {
    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const { email, name } = payload;
    console.log(`🔍 [Auth] Verifying user with email: ${email}...`);

    let user = await User.findOne({ email }).populate('companyId');

    if (!user) {
      console.log(`❌ [Auth] User with email ${email} not found in database.`);
      return res.status(401).json({ 
        message: 'Contact admin to register this email, not registered' 
      });
    }

    console.log(`✨ [Auth] Google login successful for ${user.username}`);
    res.json({
      id: user._id,
      username: user.username,
      email: user.email,
      role: user.role,
      company: user.companyId, // Return full company object
      token: generateToken(user._id),
    });

  } catch (error) {
    console.error(`💥 [Auth] Google validation failed: ${error.message}`);
    res.status(401).json({ message: 'Invalid Google Source Token' });
  }
};

exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).populate('companyId');
    if (user) {
      res.json({
        id: user._id,
        username: user.username,
        email: user.email,
        role: user.role,
        company: user.companyId,
      });
    } else {
      res.status(404).json({ success: false, error: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
