const Category = require('../models/Category');
const asyncHandler = require('express-async-handler');

// @desc    Get all categories for a company
// @route   GET /api/categories
// @access  Private
exports.getCategories = asyncHandler(async (req, res) => {
  const categories = await Category.find({ companyId: req.user.companyId }).sort({ name: 1 });
  res.json(categories);
});

// @desc    Create a new category
// @route   POST /api/categories
// @access  Private
exports.createCategory = asyncHandler(async (req, res) => {
  const { name, subcategories } = req.body;

  if (!name) {
    res.status(400);
    throw new Error('Category name is required');
  }

  const existingCategory = await Category.findOne({ 
    companyId: req.user.companyId, 
    name: { $regex: new RegExp(`^${name}$`, 'i') } 
  });

  if (existingCategory) {
    res.status(400);
    throw new Error('Category already exists');
  }

  const category = await Category.create({
    companyId: req.user.companyId,
    name,
    subcategories: subcategories || [],
  });

  res.status(201).json(category);
});

// @desc    Update a category (rename or update subcategories)
// @route   PUT /api/categories/:id
// @access  Private
exports.updateCategory = asyncHandler(async (req, res) => {
  const { name, subcategories } = req.body;
  const category = await Category.findOne({ _id: req.params.id, companyId: req.user.companyId });

  if (!category) {
    res.status(404);
    throw new Error('Category not found');
  }

  category.name = name || category.name;
  if (subcategories) {
    category.subcategories = subcategories;
  }

  const updatedCategory = await category.save();
  res.json(updatedCategory);
});

// @desc    Delete a category
// @route   DELETE /api/categories/:id
// @access  Private
exports.deleteCategory = asyncHandler(async (req, res) => {
  const category = await Category.findOneAndDelete({ _id: req.params.id, companyId: req.user.companyId });

  if (!category) {
    res.status(404);
    throw new Error('Category not found');
  }

  res.json({ message: 'Category removed' });
});

// @desc    Add a subcategory to an existing category
// @route   POST /api/categories/:id/subcategories
// @access  Private
exports.addSubcategory = asyncHandler(async (req, res) => {
  const { name } = req.body;
  const category = await Category.findOne({ _id: req.params.id, companyId: req.user.companyId });

  if (!category) {
    res.status(404);
    throw new Error('Category not found');
  }

  if (!name) {
    res.status(400);
    throw new Error('Subcategory name is required');
  }

  if (category.subcategories.includes(name)) {
    res.status(400);
    throw new Error('Subcategory already exists in this category');
  }

  category.subcategories.push(name);
  await category.save();
  res.json(category);
});
