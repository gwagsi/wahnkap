# Wahnkap - Clean Architecture Implementation

## 📁 Project Structure

This project follows **Clean Architecture** principles to ensure scalability, maintainability, and testability.

```
lib/
├── core/                   # Shared code across all features
│   ├── api/                # API client setup and endpoints
│   ├── config/             # App configuration, theme, constants
│   ├── di/                 # Dependency Injection setup
│   ├── errors/             # Custom exceptions and failures
│   ├── navigation/         # App routing and navigation
│   ├── usecases/           # Base use case definitions
│   └── common_widgets/     # Reusable UI components
│
├── features/               # Feature-based organization
│   ├── auth/               # Authentication & onboarding
│   ├── dashboard/          # Main dashboard
│   ├── payments/           # Payment processing & wallet
│   ├── trading_bots/       # Trading bot management
│   ├── investments/        # Investment programs
│   └── profile/            # User profile & settings
│
└── main.dart               # App entry point
```

## 🏗️ Clean Architecture Layers

Each feature follows these three layers:

### 📱 Presentation Layer
- **Pages**: UI screens and navigation
- **Widgets**: Feature-specific UI components  
- **BLoC/Cubit**: State management logic

### 🎯 Domain Layer
- **Entities**: Core business objects (User, Transaction, etc.)
- **Use Cases**: Business logic operations
- **Repository Interfaces**: Abstract contracts

### 💾 Data Layer
- **Data Sources**: API calls, local storage
- **Models**: Data transfer objects with JSON serialization
- **Repository Implementations**: Concrete data access

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
flutter run
```

## 📦 Key Packages

- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **injectable**: DI code generation
- **go_router**: Navigation
- **dio**: HTTP client
- **dartz**: Functional programming (Either, Option)
- **equatable**: Value equality

## 🔄 Development Workflow

### Adding a New Feature

1. **Create the folder structure**:
   ```
   features/new_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── bloc/
       ├── pages/
       └── widgets/
   ```

2. **Define entities** in `domain/entities/`
3. **Create repository interface** in `domain/repositories/`
4. **Implement use cases** in `domain/usecases/`
5. **Create data models** in `data/models/`
6. **Implement repository** in `data/repositories/`
7. **Build UI** in `presentation/`

### Code Generation

Run this command whenever you:
- Add new `@injectable` classes
- Modify JSON models with `@JsonSerializable`
- Add new API endpoints with `@RestApi`

```bash
dart run build_runner build
```

## 🎯 Core Features

### Authentication Flow
- Welcome screen with Deriv OAuth integration
- Feature tour for new users

### Main App Shell
- Bottom navigation with 5 tabs
- Persistent navigation state

### Dashboard
- Portfolio overview
- Quick actions (deposit/withdraw)
- Recent activity feed

### Payments
- Deriv integration for deposits/withdrawals
- Local wallet management
- Transaction history

### Trading Bots
- Bot marketplace
- Performance tracking
- Capital allocation

### Investments
- Managed investment programs
- Portfolio diversification
- Risk assessment

## 📋 TODO

After setting up the architecture, implement:

1. **Authentication**: Deriv OAuth integration
2. **API Integration**: Connect to real endpoints
3. **State Management**: Complete BLoC implementations
4. **Local Storage**: User preferences and caching
5. **Testing**: Unit tests for use cases and repositories
6. **CI/CD**: Automated testing and deployment

## 🧪 Testing Strategy

- **Unit Tests**: Use cases and repositories
- **Widget Tests**: Individual UI components  
- **Integration Tests**: Complete user flows
- **Golden Tests**: UI consistency

## 📚 Architecture Benefits

- **Separation of Concerns**: Each layer has a single responsibility
- **Testability**: Business logic is independent of UI and data sources
- **Scalability**: Features can be developed independently
- **Maintainability**: Changes in one layer don't affect others
- **Team Collaboration**: Multiple developers can work on different features

---

Built with ❤️ using Flutter & Clean Architecture