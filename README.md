# Jharkhand Civic Reporter - Flutter App
# Jharkhand Civic Reporter - Flutter App
=======
# Jharkhand Civic Reporter - Flutter App

## 🎯 Project Overview

A comprehensive Flutter application for Jharkhand citizens to report civic issues with real-time backend integration and admin dashboard connectivity.

## 📱 App Features

- ✅ **Citizen Authentication** (Register/Login)
- ✅ **Report Civic Issues** with photos and location
- ✅ **Real-time Status Updates** via Socket.IO
- ✅ **Profile Management**
- ✅ **My Reports Dashboard**
- ✅ **Location Services** integration
- ✅ **Offline Support** with local storage
- ✅ **Push Notifications** for report updates

## 🏗️ Project Structure

```
jharkhand_civic_reporter/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── app_config.dart
│   │   ├── api_config.dart
│   │   └── theme_config.dart
│   ├── models/
│   │   ├── citizen.dart
│   │   ├── report.dart
│   │   ├── location.dart
│   │   └── api_response.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── report_service.dart
│   │   ├── socket_service.dart
│   │   ├── location_service.dart
│   │   └── storage_service.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── report_provider.dart
│   │   └── theme_provider.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── splash_screen.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── dashboard_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── reports/
│   │   │   ├── create_report_screen.dart
│   │   │   ├── my_reports_screen.dart
│   │   │   ├── report_detail_screen.dart
│   │   │   └── camera_screen.dart
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       └── about_screen.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_textfield.dart
│   │   │   ├── loading_widget.dart
│   │   │   └── error_widget.dart
│   │   ├── report/
│   │   │   ├── report_card.dart
│   │   │   ├── report_form.dart
│   │   │   └── category_selector.dart
│   │   └── layout/
│   │       ├── app_drawer.dart
│   │       └── bottom_nav.dart
│   └── utils/
│       ├── constants.dart
│       ├── helpers.dart
│       ├── validators.dart
│       └── enums.dart
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── test/
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

## 🔧 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  http: ^1.1.0
  dio: ^5.4.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  
  # Real-time Communication
  socket_io_client: ^2.0.3+1
  
  # Location Services
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  
  # Image Handling
  image_picker: ^1.0.4
  cached_network_image: ^3.3.0
  
  # UI Components
  flutter_svg: ^2.0.9
  google_fonts: ^6.1.0
  
  # Utilities
  intl: ^0.19.0
  path: ^1.8.3
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android device/emulator or iOS device/simulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-repo/jharkhand_civic_reporter.git
cd jharkhand_civic_reporter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure backend URL**
Edit `lib/config/api_config.dart` and update the base URL:
```dart
static const String baseUrl = 'http://your-backend-url:5000';
```

4. **Run the app**
```bash
flutter run
```

## 📡 Backend Integration

### API Endpoints Used

#### Authentication
- `POST /api/flutter/register` - Citizen registration
- `POST /api/flutter/login` - Citizen login

#### Profile Management
- `GET /api/flutter/profile` - Get citizen profile
- `PUT /api/flutter/profile` - Update citizen profile

#### Reports
- `POST /api/flutter/reports` - Submit new report
- `GET /api/flutter/my-reports` - Get citizen's reports
- `GET /api/flutter/reports/:id` - Get specific report details

### Real-time Features
- Socket.IO connection for live updates
- Real-time report status notifications
- Live dashboard statistics

## 🔐 Authentication Flow

1. **Registration**: Citizens register with email, phone, and personal details
2. **Login**: Email/password authentication with JWT token
3. **Token Storage**: Secure token storage using SharedPreferences
4. **Auto-login**: Automatic login on app restart if token is valid

## 📍 Location Services

- **GPS Integration**: Automatic location detection for reports
- **Address Geocoding**: Convert coordinates to human-readable addresses
- **Location Permissions**: Handle location permission requests gracefully

## 📊 Report Management

- **Create Reports**: Submit issues with photos, descriptions, and locations
- **Track Status**: Monitor report progress in real-time
- **View History**: Access all submitted reports with filters
- **Offline Support**: Cache reports when offline and sync when online

## 🎨 UI/UX Features

- **Material Design 3**: Modern Google Material Design
- **Dark/Light Theme**: Automatic theme switching
- **Responsive Layout**: Optimized for various screen sizes
- **Loading States**: Smooth loading animations
- **Error Handling**: User-friendly error messages

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- 🔄 **Web** (Under development)

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate test coverage
flutter test --coverage
```

## 📦 Build & Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔒 Security Features

- JWT token authentication
- Secure API communications (HTTPS)
- Input validation and sanitization
- Secure local storage
- Permission-based access control

## 🌐 Localization

The app supports:
- English (Primary)
- Hindi
- Bengali (Planned)

## 📞 Support

For technical support and bug reports:
- Email: support@jharkhandi-civic.gov.in
- GitHub Issues: [Repository Issues](https://github.com/your-repo/issues)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Developed for the Government of Jharkhand**  
**Civic Issues Management System**
