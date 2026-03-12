const mongoose = require('mongoose');
const logger = require('./logger');

/**
 * Execute operations within a MongoDB transaction
 * @param {Function} operations - Async function containing database operations
 * @returns {Promise} Result of the operations
 */
const withTransaction = async (operations) => {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const result = await operations(session);
    await session.commitTransaction();
    logger.info('Transaction committed successfully');
    return result;
  } catch (error) {
    await session.abortTransaction();
    logger.error('Transaction aborted:', { error: error.message });
    throw error;
  } finally {
    session.endSession();
  }
};

module.exports = { withTransaction };
