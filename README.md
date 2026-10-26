# Shop - Flutter E-Commerce & Service Provider App

A comprehensive Flutter application built following Clean Architecture principles, SOLID design patterns, and modern development practices.

## 🏗️ Architecture

This project follows **Clean Architecture** with clear separation of concerns:

```
lib/
├── core/                    # Core business logic and utilities
│   ├── base_classes.dart    # Base classes for BLoC, Repository, etc.
│   ├── error_handler.dart   # Centralized error handling
│   └── network_service.dart # Network layer abstraction
├── config/                  # Configuration and constants
│   ├── app_config.dart      # App-wide configuration
│   ├── color/               # Color schemes
│   ├── routes/              # Navigation routes
│   └── themes/              # Theme configurations
├── data/                    # Data layer (external data sources)
│   ├── repositories/        # Repository implementations
│   └── services/            # External service integrations
├── domain/                  # Domain layer (business logic)
│   ├── entities/            # Business entities
│   ├── repositories/        # Abstract repository interfaces
│   └── usecases/            # Application use cases
├── presentation/            # Presentation layer (UI)
│   ├── blocs/               # BLoC state management
│   ├── pages/               # UI screens
│   ├── widgets/             # Reusable UI components
│   └── themes/              # UI theming
├── utils/                   # Shared utilities
│   ├── validators.dart      # Input validation utilities
│   ├── extensions/          # Dart extensions
│   ├── enums.dart           # Application enums
│   └── app_url.dart         # API endpoints
└── dependency_injection/    # Dependency injection setup
    ├── locator.dart         # Service locator configuration
    └── dependency_injection.dart # DI exports
```

## 🎯 Key Features

- **Clean Architecture**: Proper separation of concerns with data, domain, and presentation layers
- **SOLID Principles**: Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
- **BLoC Pattern**: Reactive state management for predictable UI updates
- **Dependency Injection**: GetIt for clean dependency management
- **Network Layer**: Dio-based HTTP client with interceptors and error handling
- **Error Handling**: Centralized error management with user-friendly messages
- **Input Validation**: Comprehensive validation utilities
- **Type Safety**: Extensive use of enums and sealed classes
- **Code Generation**: JSON serialization with proper models

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.11.5)
- Dart SDK (bundled with Flutter)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Update `lib/config/app_config.dart` with your API endpoints
   - Configure Firebase/Supabase if using cloud services

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS (requires macOS)
flutter build ios --release

# Web
flutter build web --release
```

## 📱 Features

### User Management
- User registration and authentication
- Profile management
- Secure token-based authentication

### E-Commerce
- Product catalog with categories
- Shopping cart functionality
- Order management
- Payment integration (placeholder)

### Service Provider
- Professional listings
- Booking system
- Appointment scheduling
- Service categories

### Communication
- Real-time chat
- Push notifications
- Message history

## 🛠️ Development Guidelines

### Code Style
- Follow Dart's official style guide
- Use `flutter_lints` for code analysis
- Maintain consistent naming conventions

### State Management
- Use BLoC pattern for complex state management
- Extend `BaseBloc` for consistent error handling
- Implement proper event/state classes

### API Integration
- Use repository pattern for data access
- Implement proper error handling in network calls
- Cache data appropriately

### Testing
```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:

```env
API_BASE_URL=https://api.yourapp.com
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
```

### API Configuration
Update `lib/config/app_config.dart` with your backend configuration.

## 📦 Dependencies

### Core Dependencies
- **flutter_bloc**: State management
- **dio**: HTTP client
- **get_it**: Dependency injection
- **equatable**: Value equality

### UI Dependencies
- **flutter_screenutil**: Responsive design
- **flutter_secure_storage**: Secure local storage

### Development Dependencies
- **flutter_lints**: Code linting
- **flutter_launcher_icons**: App icons

## 🧪 Testing Strategy

### Unit Tests
- Test business logic in BLoCs
- Test repository implementations
- Test utility functions

### Widget Tests
- Test UI components
- Test user interactions
- Test state changes

### Integration Tests
- Test complete user flows
- Test API integrations
- Test navigation

## 🚀 Deployment

### Android
```bash
flutter build apk --release
flutter install
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
firebase deploy  # or your hosting solution
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Review Checklist
- [ ] Follows Clean Architecture principles
- [ ] Implements SOLID design patterns
- [ ] Includes proper error handling
- [ ] Has unit tests for business logic
- [ ] Follows consistent code style
- [ ] Includes documentation for complex logic

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support, email support@yourapp.com or join our Discord community.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library maintainers
- Open source community
