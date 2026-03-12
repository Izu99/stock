# Quick Reference Card

## Common Commands

### Backend
```bash
npm run dev          # Start development server
npm start            # Start production server
npm run setup        # Initial setup
npm test             # Run tests
```

### Frontend
```bash
flutter run          # Run app
flutter build apk    # Build Android APK
flutter pub get      # Install dependencies
flutter clean        # Clean build files
flutter pub run build_runner build --delete-conflicting-outputs  # Generate code
```

## API Endpoints Quick Reference

### Authentication
```
POST /api/auth/register    # Register new user
POST /api/auth/login       # Login
GET  /api/auth/me          # Get current user
```

### Stock Management
```
GET    /api/stock                    # Get all stock items
POST   /api/stock                    # Create stock item
GET    /api/stock/:id                # Get single item
PUT    /api/stock/:id                # Update item
DELETE /api/stock/:id                # Delete item
GET    /api/stock/barcode/:barcode   # Find by barcode
```

### Stock Movements
```
GET  /api/stock-movements/item/:id   # Get item history
GET  /api/stock-movements            # Get all movements
POST /api/stock-movements/adjustment # Record adjustment
POST /api/stock-movements/wastage    # Record wastage
GET  /api/stock-movements/wastage/report  # Wastage report
```

### Analytics
```
GET /api/analytics/profitability/items       # Item profitability
GET /api/analytics/profitability/categories  # Category profitability
GET /api/analytics/forecast/cashflow         # Cash flow forecast
GET /api/analytics/inventory/valuation       # Inventory value
GET /api/analytics/top-sellers               # Top selling items
GET /api/analytics/reorder-list              # Items to reorder
```

### Sales
```
GET  /api/sales      # Get all sales
POST /api/sales      # Create sale
GET  /api/sales/:id  # Get single sale
```

### Expenses
```
GET    /api/expenses      # Get all expenses
POST   /api/expenses      # Create expense
GET    /api/expenses/:id  # Get single expense
PUT    /api/expenses/:id  # Update expense
DELETE /api/expenses/:id  # Delete expense
```

### Income
```
GET    /api/income      # Get all income
POST   /api/income      # Create income
GET    /api/income/:id  # Get single income
PUT    /api/income/:id  # Update income
DELETE /api/income/:id  # Delete income
```

### Dashboard
```
GET /api/dashboard/stats  # Get dashboard statistics
```

## Request Examples

### Create Stock Item
```bash
curl -X POST http://localhost:5000/api/stock \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "name": "Hammer",
    "category": "Tools",
    "quantity": 50,
    "unit": "pcs",
    "buyPrice": 10.00,
    "sellPrice": 15.00,
    "minimumLevel": 10,
    "barcode": "1234567890"
  }'
```

### Record Sale
```bash
curl -X POST http://localhost:5000/api/sales \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "itemId": "STOCK_ITEM_ID",
    "quantity": 5,
    "sellPrice": 15.00
  }'
```

### Record Wastage
```bash
curl -X POST http://localhost:5000/api/stock-movements/wastage \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "stockItemId": "STOCK_ITEM_ID",
    "quantity": 2,
    "reason": "Damaged",
    "notes": "Dropped during transport"
  }'
```

### Get Profitability
```bash
curl http://localhost:5000/api/analytics/profitability/items?startDate=2026-03-01&endDate=2026-03-31 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Error Codes

| Code | Meaning | Common Causes |
|------|---------|---------------|
| 400 | Bad Request | Invalid data, validation failed |
| 401 | Unauthorized | Missing/invalid token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate entry (e.g., barcode) |
| 500 | Server Error | Database error, unexpected error |

## Environment Variables

### Backend (.env)
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/hardware_stock
JWT_SECRET=your_secret_key
NODE_ENV=development
LOG_LEVEL=info
```

## Database Models

### StockItem
```javascript
{
  name: String,
  category: String,
  quantity: Number,
  unit: String,  // 'kg', 'L', 'pcs', 'ml', 'g', 'box', 'carton', 'bottle', 'can'
  buyPrice: Number,
  sellPrice: Number,
  minimumLevel: Number,
  barcode: String,
  bulkUnit: String,
  bulkQuantity: Number,
  sellableUnit: String,
  sellableQuantity: Number,
  unitsPerBulk: Number,
  companyId: ObjectId
}
```

### StockMovement
```javascript
{
  stockItemId: ObjectId,
  type: String,  // 'purchase', 'sale', 'adjustment', 'damage', 'wastage', 'return'
  quantity: Number,
  quantityBefore: Number,
  quantityAfter: Number,
  unitPrice: Number,
  totalValue: Number,
  reason: String,
  notes: String,
  referenceId: ObjectId,
  referenceType: String,
  performedBy: ObjectId,
  companyId: ObjectId
}
```

### Expense
```javascript
{
  title: String,
  amount: Number,
  category: String,  // 'hardware', 'utility_bills', 'stock_purchase', 'salary', 'maintenance', 'rent', 'transport', 'marketing', 'other'
  note: String,
  date: Date,
  companyId: ObjectId
}
```

## Flutter Widgets

### Using Theme Extensions
```dart
final gradients = Theme.of(context).extension<AppGradients>()!;
final shadows = Theme.of(context).extension<AppShadows>()!;

Container(
  decoration: BoxDecoration(
    gradient: gradients.primaryGradient,
    boxShadow: shadows.card,
    borderRadius: BorderRadius.circular(AppRadius.md),
  ),
  padding: EdgeInsets.all(AppSpacing.md),
)
```

### Error Handling
```dart
try {
  await apiCall();
} catch (e) {
  final exception = ErrorHandler.handleError(e);
  final message = ErrorHandler.getUserFriendlyMessage(exception);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
```

### Barcode Scanner
```dart
final barcode = await showBarcodeScanner(context);
if (barcode != null) {
  // Use barcode to search for item
}
```

### Export to PDF
```dart
await ExportUtils.exportStockReportToPdf(
  stockItems: items,
  companyName: 'My Company',
);
```

### Export to CSV
```dart
await ExportUtils.exportStockToCsv(items);
```

## Design Tokens

### Spacing
```dart
AppSpacing.xs   // 4.0
AppSpacing.sm   // 8.0
AppSpacing.md   // 16.0
AppSpacing.lg   // 24.0
AppSpacing.xl   // 32.0
AppSpacing.xxl  // 48.0
```

### Border Radius
```dart
AppRadius.sm    // 8.0
AppRadius.md    // 12.0
AppRadius.lg    // 16.0
AppRadius.xl    // 24.0
AppRadius.full  // 9999.0
```

### Colors
```dart
AppColors.success       // #10B981
AppColors.warning       // #F59E0B
AppColors.danger        // #EF4444
AppColors.info          // #3B82F6
AppColors.successLight  // #D1FAE5
AppColors.warningLight  // #FEF3C7
AppColors.dangerLight   // #FEE2E2
AppColors.infoLight     // #DBEAFE
```

## Logging

### Backend
```javascript
const logger = require('../utils/logger');

logger.info('Message', { key: 'value' });
logger.warn('Warning', { key: 'value' });
logger.error('Error', { error: error.message });
logger.debug('Debug info', { key: 'value' });
```

### Log Files
- `server/logs/combined.log` - All logs
- `server/logs/error.log` - Error logs only
- `server/logs/exceptions.log` - Uncaught exceptions
- `server/logs/rejections.log` - Unhandled promise rejections

## Testing

### Test API with curl
```bash
# Get token
TOKEN=$(curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}' \
  | jq -r '.token')

# Use token
curl http://localhost:5000/api/stock \
  -H "Authorization: Bearer $TOKEN"
```

### Test with Postman
1. Create environment variable `baseUrl` = `http://localhost:5000/api`
2. Create environment variable `token` = `YOUR_TOKEN`
3. Use `{{baseUrl}}` and `{{token}}` in requests

## Useful MongoDB Queries

```javascript
// Connect to database
mongosh hardware_stock

// View collections
show collections

// Count documents
db.stockitems.countDocuments()

// Find low stock items
db.stockitems.find({ $expr: { $lte: ['$quantity', '$minimumLevel'] } })

// Get stock movements for today
db.stockmovements.find({
  date: {
    $gte: new Date(new Date().setHours(0,0,0,0))
  }
})

// Calculate total inventory value
db.stockitems.aggregate([
  {
    $group: {
      _id: null,
      totalValue: { $sum: { $multiply: ['$quantity', '$buyPrice'] } }
    }
  }
])
```

## Performance Tips

### Backend
- Use indexes on frequently queried fields
- Use transactions for multi-document operations
- Implement pagination for large datasets
- Cache frequently accessed data
- Use lean() for read-only queries

### Frontend
- Use const constructors where possible
- Implement lazy loading for lists
- Cache API responses with Riverpod
- Use keys for list items
- Optimize images and assets

## Security Checklist

- [ ] Change default JWT_SECRET
- [ ] Use HTTPS in production
- [ ] Enable MongoDB authentication
- [ ] Validate all user inputs
- [ ] Sanitize data before database operations
- [ ] Implement rate limiting
- [ ] Use secure password hashing (bcrypt)
- [ ] Keep dependencies updated
- [ ] Use environment variables for secrets
- [ ] Implement proper CORS configuration

## Deployment Checklist

- [ ] Set NODE_ENV=production
- [ ] Configure production database
- [ ] Set up SSL certificates
- [ ] Configure reverse proxy (nginx)
- [ ] Set up process manager (PM2)
- [ ] Configure log rotation
- [ ] Set up monitoring
- [ ] Configure backups
- [ ] Test all endpoints
- [ ] Update API base URL in frontend

## Resources

- [Express.js Documentation](https://expressjs.com/)
- [Mongoose Documentation](https://mongoosejs.com/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Winston Logger](https://github.com/winstonjs/winston)
- [Express Validator](https://express-validator.github.io/)
