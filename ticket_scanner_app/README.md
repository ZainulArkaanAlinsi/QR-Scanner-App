# 🎫 Ticket Scanner App

Modern Flutter application for QR-based event ticket management.

## 📱 App Features

- **User Authentication** - Login/Register dengan role-based access (Admin/Attendee)
- **Event Discovery** - Browse, search, dan view event details
- **Ticket Reservation** - Reserve tickets untuk events
- **QR Code Scanner** - Scan tickets untuk check-in (Admin only)
- **My Tickets** - View, manage, dan cancel tickets
- **Modern UI** - Beautiful gradient designs, animations, dan glassmorphism effects

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **HTTP Client**: Dio
- **QR Scanning**: mobile_scanner
- **QR Generation**: qr_flutter
- **Image Caching**: cached_network_image
- **Google Fonts**: google_fonts

## 📁 Project Structure

```
lib/
├── core/
│   ├── api_client.dart       # HTTP client configuration
│   ├── themes/app_theme.dart # UI theme & colors
│   └── utils/                # Helpers, validators, constants
├── models/
│   ├── user_model.dart       # User data model
│   ├── event_model.dart      # Event data model
│   ├── ticket_model.dart     # Ticket data model
│   └── api_response.dart    # API response wrapper
├── providers/
│   ├── auth_provider.dart   # Authentication state
│   ├── event_provider.dart   # Events state
│   ├── ticket_provider.dart  # Tickets state
│   └── api_provider.dart     # API utilities
├── services/
│   ├── auth_service.dart     # Auth API calls
│   ├── event_service.dart    # Event API calls
│   └── ticket_service.dart   # Ticket API calls
├── screens/
│   ├── splash_screen.dart    # App splash/loading
│   ├── auth_screen.dart      # Login/Register
│   ├── home_screen.dart      # Main navigation
│   ├── my_tickets_screen.dart
│   ├── qr_scanner_screen.dart
│   ├── event_detail_screen.dart
│   ├── event_form_screen.dart
│   └── tabs/                 # Bottom tab screens
│       ├── home_tab.dart
│       ├── events_tab.dart
│       ├── profile_tab.dart
│       └── my_tickets_tab.dart
├── widgets/
│   ├── event_tile.dart       # Event card widget
│   ├── featured_carousel.dart
│   ├── status_badge.dart
│   ├── error_card.dart
│   ├── input_field.dart
│   └── loading_button.dart
├── controllers/
│   └── navigation_controller.dart
└── main.dart                 # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0
- Android SDK / Xcode (for iOS)
- Laravel backend running di `http://localhost:8000`

### Installation

```bash
# Install dependencies
flutter pub get

# Run build runner (jika menggunakan Envied)
dart run build_runner build

# Run the app
flutter run
```

### Configuration

Edit API configuration di `lib/env/env.dart`:

```dart
// Base URL - sesuai platform
// Android Emulator: http://10.0.2.2:8000/api
// iOS Simulator: http://localhost:8000/api
// Physical Device: Use IP address komputer

static final String baseUrl = 'http://10.0.2.2:8000/api';
static final String apiKey = 'K8vskiIaHsvc8NOvBpmAInxvq8YS6kuP';
```

## 🎨 UI/UX Design

### Theme Colors
- **Primary**: #6366F1 (Indigo)
- **Secondary**: #10B981 (Emerald)
- **Accent**: #F59E0B (Amber)
- **Background**: #F8FAFC
- **Text Primary**: #1E293B
- **Text Secondary**: #64748B

### Screen Designs
- **Splash** - Gradient background dengan animated logo
- **Auth** - Tab-based (Login/Register) dengan background decorations
- **Home** - Gradient header, featured carousel, event list
- **Event Detail** - Sliver app bar dengan stat chips
- **My Tickets** - Modern card design dengan QR display
- **QR Scanner** - Full screen camera dengan overlay UI

## 🔐 Authentication Flow

1. **Splash Screen** - Check stored token
2. **Auth Screen** - Login atau Register
3. **Home Screen** - Main tab navigation
   - **Admin**: Dashboard, Events Management, Scanner, Profile
   - **Attendee**: Explore, My Tickets, Profile

## 📡 API Integration

### Endpoints yang digunakan

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/register` | Register user |
| POST | `/login` | Login |
| POST | `/logout` | Logout |
| GET | `/user` | Get profile |
| GET | `/event` | Get events |
| GET | `/event/{id}` | Get event detail |
| POST | `/event` | Create event (Admin) |
| PUT | `/event/{id}` | Update event (Admin) |
| DELETE | `/event/{id}` | Delete event (Admin) |
| POST | `/event/{id}/reserve` | Reserve ticket |
| GET | `/my-tickets` | Get my tickets |
| PATCH | `/ticket/{id}/cancel` | Cancel ticket |
| PATCH | `/ticket/{id}/checkin` | Check-in (Admin) |

## 🐛 Troubleshooting

### Connection Issues
- Pastikan Laravel backend running
- Cek URL sesuai platform (10.0.2.2 untuk Android)
-cek API key di `.env`

### Build Issues
```bash
# Clean dan rebuild
flutter clean
flutter pub get
flutter build apk --debug
```

## 📄 License

MIT License