"# Hardware Stock Sales Management System

A comprehensive stock management system with advanced analytics, built with Flutter (frontend) and Node.js (backend).

## Features

### UI/UX
- 🎨 Modern, colorful UI design (inspired by Helakuru)
- 🎯 Icon-based navigation with gradient backgrounds
- 📱 Card-based layout with smooth animations
- 🌈 Light theme with vibrant colors
- ✨ Professional button styles and components

### Core Functionality
- 📦 Stock Management with barcode support
- 💰 Sales tracking with profit calculation
- 📊 Income & Expense management
- 👥 Multi-user support with role-based access
- 🏢 Multi-company support

### Advanced Features (New!)
- 📈 Profitability analytics per item/category
- 💵 Cash flow forecasting
- 📉 Stock movement history tracking
- ⚠️ Per-item low stock thresholds
- 🔄 Unit conversion system (bulk to sellable units)
- 📱 Barcode/QR scanner
- 🗑️ Wastage & damage tracking
- 📑 PDF/CSV export for reports
- 💡 Smart reorder suggestions
- 🎯 Top sellers dashboard
- 💎 Inventory valuation

### Backend Refinements
- ✅ Centralized error handling
- ✅ Database transactions for data integrity
- ✅ Request validation with express-validator
- ✅ Structured logging with Winston
- ✅ Consistent API responses

## Tech Stack

### Backend
- Node.js & Express
- MongoDB with Mongoose
- JWT Authentication
- Winston Logger
- Express Validator

### Frontend
- Flutter 3.10+
- Riverpod (State Management)
- Dio (HTTP Client)
- FL Chart (Charts)
- Mobile Scanner (Barcode)
- PDF & CSV Export
- Modern UI Design (Helakuru-inspired)

## Quick Start

### Backend Setup

```bash
cd server
npm install
npm run setup
cp .env.example .env  # Configure your environment
npm run dev
```

### Frontend Setup

```bash
cd client
flutter pub get
flutter run
```

## Environment Variables

Create `server/.env`:

```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/hardware_stock
JWT_SECRET=your_secret_key
NODE_ENV=development
LOG_LEVEL=info
```

## API Documentation

### Analytics Endpoints
- `GET /api/analytics/profitability/items` - Item profitability
- `GET /api/analytics/profitability/categories` - Category profitability
- `GET /api/analytics/forecast/cashflow` - Cash flow forecast
- `GET /api/analytics/inventory/valuation` - Inventory valuation
- `GET /api/analytics/top-sellers` - Top selling items
- `GET /api/analytics/reorder-list` - Items to reorder

### Stock Movement Endpoints
- `GET /api/stock-movements/item/:id` - Movement history
- `POST /api/stock-movements/adjustment` - Record adjustment
- `POST /api/stock-movements/wastage` - Record wastage
- `GET /api/stock-movements/wastage/report` - Wastage report

See [ENHANCEMENTS_GUIDE.md](./ENHANCEMENTS_GUIDE.md) for complete documentation.

## Project Structure

```
.
├── server/                 # Node.js backend
│   ├── src/
│   │   ├── controllers/   # Request handlers
│   │   ├── models/        # Database models
│   │   ├── routes/        # API routes
│   │   ├── middleware/    # Custom middleware
│   │   └── utils/         # Utilities
│   ├── logs/              # Application logs
│   └── server.js          # Entry point
│
├── client/                # Flutter frontend
│   ├── lib/
│   │   ├── core/         # Core utilities
│   │   │   ├── error/    # Error handling
│   │   │   ├── theme/    # Theme & design tokens
│   │   │   ├── utils/    # Utilities
│   │   │   └── widgets/  # Reusable widgets
│   │   └── features/     # Feature modules
│   └── pubspec.yaml
│
├── IMPLEMENTATION_PLAN.md  # Development roadmap
└── ENHANCEMENTS_GUIDE.md   # Detailed feature guide
```

## Key Enhancements

### 1. Stock Management
- Per-item minimum stock levels
- Complete movement history (purchase, sale, adjustment, wastage)
- Unit conversion (e.g., 20L drum → 40x 500ml bottles)
- Barcode scanning for quick item lookup

### 2. Financial Analytics
- Real-time profitability tracking
- 30-day cash flow forecasting
- Expense categorization (9 categories)
- Tax/VAT ready calculations

### 3. Reports & Export
- PDF stock reports
- PDF profit statements
- CSV exports
- WhatsApp/Email sharing

### 4. Developer Experience
- Centralized error handling
- Structured logging
- Database transactions
- Request validation
- Consistent API responses

## Mobile Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for barcode scanning</string>
```

## Development

### Run Backend Tests
```bash
cd server
npm test
```

### Run Frontend
```bash
cd client
flutter run
```

### Build for Production
```bash
# Backend
cd server
npm start

# Frontend
cd client
flutter build apk  # Android
flutter build ios  # iOS
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - see LICENSE file for details

## Modern UI Design

The app now includes a modern, colorful UI design inspired by Helakuru:
- Gradient icon backgrounds
- Card-based layouts
- Modern button styles
- Vibrant color palette
- Professional typography

See [MODERN_UI_GUIDE.md](./MODERN_UI_GUIDE.md) for complete UI documentation.

## Support

For detailed documentation, see:
- [MODERN_UI_GUIDE.md](./MODERN_UI_GUIDE.md) - Modern UI design guide
- [ENHANCEMENTS_GUIDE.md](./ENHANCEMENTS_GUIDE.md) - Complete feature documentation
- [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md) - Development roadmap

## Changelog

### v2.0.0 (March 2026)
- ✅ Added centralized error handling
- ✅ Implemented database transactions
- ✅ Added request validation
- ✅ Integrated Winston logging
- ✅ Stock movement history tracking
- ✅ Profitability analytics
- ✅ Cash flow forecasting
- ✅ Barcode scanner
- ✅ PDF/CSV export
- ✅ Enhanced theming system
- ✅ Robust error handling (frontend)

### v1.0.0
- Initial release with basic stock management
" 
