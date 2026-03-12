/**
 * Detailed Logger Middleware
 * Captures request details, body, user info, and performance metrics.
 */
const detailedLogger = (req, res, next) => {
  const start = Date.now();
  const timestamp = new Date().toISOString();
  
  // Hide sensitive fields from logs
  const sanitizeBody = (body) => {
    if (!body) return body;
    const sanitized = { ...body };
    const sensitiveFields = ['password', 'token', 'confirmPassword', 'secret'];
    
    sensitiveFields.forEach(field => {
      if (sanitized[field]) sanitized[field] = '********';
    });
    
    return sanitized;
  };

  // Log request start
  console.log(`
[${timestamp}] 📥 REQUEST: ${req.method} ${req.originalUrl}`);
  
  if (Object.keys(req.query).length > 0) {
    console.log(`   🔍 Query: ${JSON.stringify(req.query)}`);
  }
  
  if (req.body && Object.keys(req.body).length > 0) {
    console.log(`   📦 Body: ${JSON.stringify(sanitizeBody(req.body), null, 2)}`);
  }

  // Once the request is finished
  res.on('finish', () => {
    const duration = Date.now() - start;
    const statusColor = res.statusCode >= 400 ? '❌' : '✅';
    const userStr = req.user ? ` (User: ${req.user._id})` : ' (Guest)';
    
    console.log(`${statusColor} RESPONSE: ${res.statusCode} | ${duration}ms${userStr}`);
  });

  next();
};

module.exports = detailedLogger;
