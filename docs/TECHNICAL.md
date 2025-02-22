# Technical Documentation

## Project Structure

```
lib/
├── utils/
│   ├── constants/
│   ├── theme/
│   ├── helpers/
│   ├── storage/
│   └── exceptions/
├── data/
│   ├── analysis/analysis repositories
│   ├── authentication repository/
│   └── user repository/
├── features/
│   ├── authentication/
│   ├── analysis/
│   ├── demo/
│   └── personalization/
└── main.dart
```

## Tech Stack Details

### Frontend (Flutter)
- State Management: GetX
- Local Storage: GetStorage
- Network: Connectivity Plus
- File Handling: File Picker
- Image Processing: Image Picker

### Backend (Supabase)
- Authentication
- User Management
- File Storage
- Analysis History

### Machine Learning
- Model: Dense Layer Neural Network
- Implementation: TFLite Flutter
- Input: SNP variant data
- Output: Metabolism classification and analysis

## Key Features Implementation

### SNP Analysis
```dart
// Analysis workflow
1. File Upload -> Parsing -> Validation
2. Extract SNP variants
3. Process through ML model
4. Generate results
```

### Authentication Flow
```dart
// Auth States
1. Initial -> Check existing session
2. Unauthenticated -> Login/Register/Guest
3. Authenticated -> Main App Flow
```

### Data Management
- Secure storage for sensitive data
- Regular sync with backend

## API Endpoints

### Authentication
- POST /auth/register
- POST /auth/login
- POST /auth/logout

### Analysis
- POST /analysis/quick-scan
- POST /analysis/full-scan
- GET /analysis/history

## Security Features

### Data Protection
- Secure file handling
- Token-based authentication

### Privacy
- Local data processing
- Minimal data collection

## Development Setup

### Prerequisites
```bash
flutter --version
# Flutter 3.27.0
# Dart 3.4.0
```

### Environment Setup
1. Clone repository
2. Install dependencies
3. Configure environment variables
4. Run in debug mode

### Building for Production
```bash
flutter build apk --release
```

### Memory Management
- File cleanup after analysis
- Cache size limits
- Resource disposal

## Contribution Guidelines

1. Fork repository
2. Create feature branch
3. Follow code style
4. Submit pull request
