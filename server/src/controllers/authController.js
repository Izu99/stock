const User = require('../models/User');
const jwt = require('jsonwebtoken');

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });
};

exports.registerUser = async (req, res) => {
  const { username, email, password, role } = req.body;
  try {
    const userExists = await User.findOne({ $or: [{ email }, { username }] });
    if (userExists) return res.status(400).json({ message: 'User already exists' });

    const user = await User.create({ username, email, password, role });
    res.status(201).json({
      id: user._id,
      username: user.username,
      email: user.email,
      role: user.role,
      token: generateToken(user._id),
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.loginUser = async (req, res) => {
  const { password } = req.body;
  const username = req.body.username.toLowerCase();
  console.log(`[AUTH] Login attempt for username: ${username}`);
  try {
    const user = await User.findOne({ username });
    if (!user) {
      console.log(`[AUTH] Login failed: User not found for username: ${username}`);
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    const isMatch = await user.matchPassword(password);
    if (isMatch) {
      console.log(`[AUTH] Login successful for user: ${username} (ID: ${user._id})`);
      res.json({
        id: user._id,
        username: user.username,
        email: user.email,
        role: user.role,
        token: generateToken(user._id),
      });
    } else {
      console.log(`[AUTH] Login failed: Incorrect password for user: ${username}`);
      res.status(401).json({ message: 'Invalid username or password' });
    }
  } catch (error) {
    console.error(`[AUTH] Server error during login: ${error.message}`);
    res.status(500).json({ message: error.message });
  }
};
