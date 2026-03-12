const fs = require('fs');
const path = require('path');

// Create logs directory if it doesn't exist
const logsDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir);
  console.log('✅ Created logs directory');
} else {
  console.log('✅ Logs directory already exists');
}

console.log('\n📦 Installing dependencies...');
console.log('Run: npm install\n');

console.log('🎉 Setup complete! You can now run:');
console.log('   npm run dev    - Start development server');
console.log('   npm start      - Start production server\n');
