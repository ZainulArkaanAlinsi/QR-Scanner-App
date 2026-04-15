# Ticket Scanner - QR Code Event Management System

Sistem manajemen tiket event berbasis QR code dengan API backend (Laravel) dan mobile app (Flutter).

## Arsitektur Sistem

```
+-------------------------------------------------------------+
|                    Ticket Scanner System                    |
+-------------------------------------------------------------+
|                                                              |
|  +---------------------+        +-------------------------+  |
|  |   Mobile App       |        |     Laravel API         |  |
|  |   (Flutter)        | -----> |     (Backend)          |  |
|  |                     |  HTTP  |                       |  |
|  |  - User Login       |        |  - Auth (Sanctum)     |  |
|  |  - Browse Events   |        |  - Event CRUD          |  |
|  |  - Reserve Tickets |        |  - Ticket Management   |  |
|  |  - QR Scanner      |        |  - Check-in Validation |  |
|  |  - View My Tickets |        |  - Role-based Access   |  |
|  +---------------------+        +-------------------------+  |
|                                                              |
+-------------------------------------------------------------+
```

## Mobile App (Flutter)

### Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **HTTP Client**: Dio
- **QR Scanning**: mobile_scanner
- **QR Generation**: qr_flutter

### Fitur

- Login/Register dengan role-based
- Browse & search events
- Reserve tickets untuk events
- Scan QR code untuk check-in
- View & manage tickets
- Cancel tickets
- Modern UI dengan gradient & animations

### Struktur Project

```
ticket_scanner_app/
├── lib/
│   ├── core/
│   │   ├── api_client.dart       # HTTP client configuration
│   │   ├── themes/app_theme.dart # UI theme & colors
│   │   └── utils/                # Helpers, validators
│   ├── models/                   # Data models (User, Event, Ticket)
│   ├── providers/                # State management (Auth, Event, Ticket)
│   ├── services/                 # API services
│   ├── screens/                  # UI screens
│   │   ├── auth_screen.dart      # Login/Register
│   │   ├── home_screen.dart      # Main navigation
│   │   ├── tabs/                 # Bottom tab screens
│   │   ├── qr_scanner_screen.dart
│   │   └── event_detail_screen.dart
│   └── widgets/                  # Reusable UI components
└── pubspec.yaml
```

### Cara Menjalankan

```bash
cd ticket_scanner_app
flutter pub get
flutter run
```

### Konfigurasi

Edit file `.env` untuk set API URL:

```dart
// lib/env/env.dart
baseUrl: 'http://10.0.2.2:8000/api' // Android emulator
// atau 'http://localhost:8000/api' // iOS simulator
API_KEY: 'K8vskiIaHsvc8NOvBpmAInxvq8YS6kuP'
```

---

## Backend API (Laravel)

### Tech Stack

- **Framework**: Laravel 11
- **Database**: MySQL
- **Authentication**: Laravel Sanctum (Token-based)
- **PHP Version**: 8.2+

### Struktur Project

```
Api_Scaning_ticket/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/
│   │   │   ├── AuthController.php   # Register, Login, Logout
│   │   │   ├── EventController.php  # Event CRUD
│   │   │   └── TicketController.php # Ticket & Check-in
│   │   └── Middleware/
│   │       ├── ApiKeyMiddleware.php # API Key validation
│   │       └── RoleMiddleware.php    # Role-based access
│   └── Models/
│       ├── User.php
│       ├── Event.php
│       └── Ticket.php
├── database/migrations/
├── routes/api.php
└── .env
```

### Cara Menjalankan Backend

```bash
# Install dependencies
composer install

# Setup environment
copy .env.example .env
php artisan key:generate

# Setup database di .env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=api_scanning_ticket
DB_USERNAME=root
DB_PASSWORD=

# Run migration & seeder
php artisan migrate
php artisan db:seed

# Link storage untuk upload gambar
php artisan storage:link

# Run server
php artisan serve
```

Server berjalan di: `http://localhost:8000`

---

## API Endpoints

Base URL: `http://localhost:8000/api`

### Public Endpoints (No Auth)

| Method | Endpoint   | Description         |
|--------|------------|---------------------|
| POST   | `/register` | Register user baru |
| POST   | `/login`    | Login user          |

### Protected Endpoints

| Method | Endpoint               | Role      | Description              |
|--------|------------------------|-----------|--------------------------|
| GET    | `/user`                | All       | Get user profile         |
| POST   | `/logout`              | All       | Logout user              |
| GET    | `/event`               | All       | Get all events           |
| GET    | `/event/{id}`          | All       | Get event detail         |
| POST   | `/event`               | Admin     | Create event             |
| PUT    | `/event/{id}`          | Admin     | Update event             |
| DELETE | `/event/{id}`          | Admin     | Delete event             |
| POST   | `/event/{id}/reserve` | Attendee  | Reserve ticket           |
| GET    | `/my-tickets`          | Attendee  | Get my tickets           |
| PATCH  | `/ticket/{id}/cancel` | Attendee  | Cancel ticket            |
| GET    | `/event/{id}/ticket`  | Admin     | Get event tickets        |
| PATCH  | `/ticket/{id}/checkin`| Admin     | Check-in ticket          |

### Request Headers

```text
Content-Type: application/json
X-API-KEY: K8vskiIaHsvc8NOvBpmAInxvq8YS6kuP
Authorization: Bearer {token}
```

### Response Format

```json
{
  "status": "Success",
  "message": "Description",
  "data": { ... }
}
```

---

## QR Code Format

Tiket menggunakan QR code dengan format:

```
ikutan-{unique_id}-{base64_encoded_payload}
```

Payload ter-encode:

```json
{
  "un": "user_id",
  "ue": "user_email",
  "en": "event_name",
  "ed": "event_date"
}
```

---

## Fitur Utama

### Mobile App

- **Modern UI** - Gradient designs, animations, glassmorphism
- **Event Discovery** - Browse & search events
- **Ticket Management** - View, reserve, cancel tickets
- **QR Scanner** - Scan tickets untuk check-in
- **Profile** - User info & settings

### Backend API

- **Authentication** - Secure token-based (Sanctum)
- **Role-based Access** - Admin & Attendee permissions
- **Event Management** - Full CRUD operations
- **Ticket System** - Reserve, cancel, check-in
- **QR Validation** - Validate & process check-ins
- **API Key Security** - Middleware protection

---

## Role Permissions

| Feature                  | Admin | Attendee |
|--------------------------|-------|----------|
| Browse Events            | Yes   | Yes      |
| Create Event             | Yes   | No       |
| Update Event             | Yes   | No       |
| Delete Event             | Yes   | No       |
| Reserve Ticket           | Yes   | Yes      |
| View My Tickets          | Yes   | Yes      |
| Cancel Ticket            | Yes   | Yes      |
| Scan & Check-in          | Yes   | No       |
| View All Tickets         | Yes   | No       |

---

## Tech Stack Summary

| Layer          | Technology              |
|----------------|------------------------|
| Frontend Mobile| Flutter, Provider      |
| Backend        | Laravel 11             |
| Database       | MySQL                  |
| Auth           | Laravel Sanctum        |
| API Security   | Custom API Key Middleware |

---

## Catatan

- **Android Emulator**: Use `10.0.2.2` untuk akses localhost
- **iOS Simulator**: Use `localhost` atau `127.0.0.1`
- **API Key**: Sudah di-config di `.env` untuk mobile
- **Seeding**: Jalankan `php artisan db:seed` untuk data dummy

---

## License

MIT License