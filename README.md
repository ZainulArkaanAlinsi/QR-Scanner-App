# 🎫 QR Code Ticket Scanning API

API untuk validasi QR code tiket event dengan sistem reservasi dan check-in. Proyek ini merupakan bagian dari SKL #1 - Part 1 (Backend API Only).

## 📋 Deskripsi Proyek

API ini menyediakan sistem manajemen tiket event yang lengkap dengan fitur:

- ✅ Validasi QR code tiket
- 🎟️ Reservasi tiket untuk event
- 🔐 Autentikasi user dengan role-based access (Admin & Attendee)
- 📊 Manajemen event (CRUD)
- ✔️ Check-in tiket menggunakan QR code
- 🚫 Pembatalan tiket

## 🛠️ Tech Stack

- **Framework**: Laravel 11
- **Database**: MySQL
- **Authentication**: Laravel Sanctum (Token-based)
- **PHP Version**: 8.2+

## 📁 Struktur Project

```text
Api_Scaning_ticket/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php      # Authentication endpoints
│   │   │       ├── EventController.php     # Event management
│   │   │       └── TicketController.php    # Ticket & QR validation
│   │   └── Middleware/
│   │       └── RoleMiddleware.php          # Role-based access control
│   ├── Models/
│   │   ├── User.php
│   │   ├── Event.php
│   │   └── Ticket.php
│   └── ApiResponse.php                     # Standardized API responses
├── database/
│   └── migrations/
├── routes/
│   └── api.php                             # API routes definition
└── README.md
```

## 🚀 Cara Menjalankan Project

### Prerequisites

- PHP >= 8.2
- Composer
- MySQL
- Git

### Langkah Instalasi

1. **Clone repository**

    ```bash
    git clone <repository-url>
    cd Api_Scaning_ticket
    ```

2. **Install dependencies**

    ```bash
    composer install
    ```

3. **Setup environment**

    ```bash
    copy .env.example .env
    ```

4. **Konfigurasi database di `.env`**

    ```env
    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=api_scanning_ticket
    DB_USERNAME=root
    DB_PASSWORD=
    ```

5. **Generate application key**

    ```bash
    php artisan key:generate
    ```

6. **Jalankan migration**

    ```bash
    php artisan migrate
    ```

7. **Create storage link (untuk upload gambar event)**

    ```bash
    php artisan storage:link
    ```

8. **Jalankan server**

    ```bash
    php artisan serve
    ```

    Server akan berjalan di: `http://localhost:8000`

## 📡 API Endpoints

Base URL: `http://localhost:8000/api`

### 🔓 Public Endpoints (No Authentication)

#### 1. Register User

```http
POST /register
```

**Request Body:**

```json
{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "role": "attendee" // optional: "admin" or "attendee" (default: attendee)
}
```

**Response (201):**

```json
{
    "status": "Success",
    "message": "User registered successfully",
    "data": {
        "token": "1|abcdef123456...",
        "user": {
            "id": "01JQWE...",
            "name": "John Doe",
            "email": "john@example.com",
            "role": "attendee"
        }
    }
}
```

#### 2. Login

```http
POST /login
```

**Request Body:**

```json
{
    "email": "john@example.com",
    "password": "password123"
}
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "User logged in successfully",
    "data": {
        "token": "2|xyz789...",
        "user": {
            "id": "01JQWE...",
            "name": "John Doe",
            "email": "john@example.com",
            "role": "attendee"
        }
    }
}
```

---

### 🔒 Protected Endpoints (Require Authentication)

**Header yang diperlukan:**

```text
Authorization: Bearer {your_token}
```

#### 3. Get User Profile

```http
GET /user
```

**Response (200):**

```json
{
    "id": "01JQWE...",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "attendee"
}
```

#### 4. Logout

```http
POST /logout
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "Logout success",
    "data": null
}
```

#### 5. Get All Events

```http
GET /event
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "Events retrieved successfully",
    "data": [
        {
            "id": "01JQWE...",
            "name": "Tech Conference 2026",
            "description": "Annual technology conference",
            "images": ["/storage/events/abc123.jpg"],
            "date": "2026-03-15T09:00:00.000000Z",
            "max_reservation": 100,
            "tickets_count": 45
        }
    ]
}
```

#### 6. Get Event Detail

```http
GET /event/{eventId}
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "Event retrieved successfully",
    "data": {
        "id": "01JQWE...",
        "name": "Tech Conference 2026",
        "description": "Annual technology conference",
        "images": ["/storage/events/abc123.jpg"],
        "date": "2026-03-15T09:00:00.000000Z",
        "max_reservation": 100,
        "tickets_count": 45
    }
}
```

---

### 👥 Attendee Only Endpoints

#### 7. Reserve Ticket

```http
POST /event/{eventId}/reserve
```

**Response (201):**

```json
{
    "status": "Success",
    "message": "Ticket created successfully",
    "data": {
        "id": "01JQWE...",
        "user_id": "01JQWE...",
        "event_id": "01JQWE...",
        "code": "ikutan-65d8f9a1b2c3d-eyJ1biI6IjAxSlFXRS4uLiIsInVlIjoiam9obkBleGFtcGxlLmNvbSIsImVuIjoiVGVjaCBDb25mZXJlbmNlIDIwMjYiLCJlZCI6IjIwMjYtMDMtMTVUMDk6MDA6MDAuMDAwMDAwWiJ9",
        "is_canceled": false,
        "is_checked_at": null,
        "created_at": "2026-02-17T10:00:00.000000Z"
    }
}
```

**Error Responses:**

- `400` - Event already ended
- `400` - You already have a ticket for this event
- `400` - Event is full
- `404` - Event not found

#### 8. Get My Tickets

```http
GET /my-tickets
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "Tickets retrieved successfully",
    "data": [
        {
            "id": "01JQWE...",
            "user_id": "01JQWE...",
            "event_id": "01JQWE...",
            "code": "ikutan-65d8f9a1b2c3d-...",
            "is_canceled": false,
            "is_checked_at": null
        }
    ]
}
```

#### 9. Cancel Ticket

```http
PATCH /ticket/{ticketId}/cancel
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "Ticket canceled successfully",
    "data": {
        "id": "01JQWE...",
        "is_canceled": true
    }
}
```

**Error Responses:**

- `400` - Ticket is already canceled
- `400` - Ticket already checked in
- `404` - Ticket not found

---

### 👨‍💼 Admin Only Endpoints

#### 10. Create Event

```http
POST /event
Content-Type: multipart/form-data
```

**Request Body (Form Data):**

```text
name: Tech Conference 2026
description: Annual technology conference
images[]: [file1.jpg]
images[]: [file2.jpg]
date: 2026-03-15 09:00:00
max_reservation: 100
```

**Response (201):**

```json
{
    "status": "Success",
    "message": "Event created successfully",
    "data": {
        "id": "01JQWE...",
        "name": "Tech Conference 2026",
        "description": "Annual technology conference",
        "images": ["/storage/events/abc123.jpg"],
        "date": "2026-03-15T09:00:00.000000Z",
        "max_reservation": 100
    }
}
```

#### 11. Update Event

```http
POST /event/{eventId}
Content-Type: multipart/form-data
```

**Request Body (Form Data - all optional):**

```text
name: Updated Event Name
description: Updated description
images[]: [new_file.jpg]
date: 2026-04-20 10:00:00
max_reservation: 150
```

**Response (200):**

```json
{
  "status": "Success",
  "message": "Event updated successfully",
  "data": { ... }
}
```

#### 12. Delete Event

```http
DELETE /event/{eventId}
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "Event deleted successfully",
    "data": null
}
```

#### 13. Get Event Tickets (Admin View)

```http
GET /event/{eventId}/ticket
```

**Response (200):**

```json
{
    "status": "Success",
    "message": "Tickets retrieved successfully",
    "data": [
        {
            "id": "01JQWE...",
            "user_id": "01JQWE...",
            "event_id": "01JQWE...",
            "code": "ikutan-65d8f9a1b2c3d-...",
            "is_canceled": false,
            "is_checked_at": null
        }
    ]
}
```

#### 14. Check-in Ticket (QR Code Validation) ✅

```http
PATCH /ticket/{ticketId}/checkin
```

**Request Body:**

```json
{
    "code": "ikutan-65d8f9a1b2c3d-eyJ1biI6IjAxSlFXRS4uLiIsInVlIjoiam9obkBleGFtcGxlLmNvbSIsImVuIjoiVGVjaCBDb25mZXJlbmNlIDIwMjYiLCJlZCI6IjIwMjYtMDMtMTVUMDk6MDA6MDAuMDAwMDAwWiJ9"
}
```

**Response (200) - Valid:**

```json
{
    "status": "Success",
    "message": "Ticket checked in successfully",
    "data": {
        "id": "01JQWE...",
        "code": "ikutan-65d8f9a1b2c3d-...",
        "is_checked_at": "2026-02-17T10:30:00.000000Z"
    }
}
```

**Error Responses:**

- `404` - Ticket not found / Invalid QR Code
- `400` - Ticket is canceled
- `400` - Ticket already checked in / Already Used

---

## 🔑 QR Code Format

Setiap tiket memiliki QR code dengan format:

```json
ikutan-{unique_id}-{base64_encoded_payload}
```

**Payload yang di-encode:**

```json
{
    "un": "user_id",
    "ue": "user_email",
    "en": "event_name",
    "ed": "event_date"
}
```

## 📊 HTTP Status Codes

| Code | Meaning                                              |
| ---- | ---------------------------------------------------- |
| 200  | Success                                              |
| 201  | Created                                              |
| 400  | Bad Request (validation error, business logic error) |
| 401  | Unauthorized (wrong password)                        |
| 403  | Forbidden (insufficient role)                        |
| 404  | Not Found                                            |
| 500  | Internal Server Error                                |

## 🔐 Role-Based Access Control

| Role         | Permissions                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------------ |
| **attendee** | Reserve tickets, view own tickets, cancel tickets                                                |
| **admin**    | All attendee permissions + Create/Update/Delete events, Check-in tickets, View all event tickets |

## 🧪 Testing dengan Postman

1. **Register** sebagai admin dan attendee
2. **Login** untuk mendapatkan token
3. **Set Authorization Header**: `Bearer {token}`
4. **Create Event** (sebagai admin)
5. **Reserve Ticket** (sebagai attendee)
6. **Check-in** menggunakan QR code (sebagai admin)

## 📝 Database Schema

### Users Table

- id (ULID)
- name
- email
- password
- role (admin/attendee)

### Events Table

- id (ULID)
- name
- description
- images (JSON array)
- date (datetime)
- max_reservation (integer)

### Tickets Table

- id (ULID)
- user_id (FK)
- event_id (FK)
- code (unique QR code)
- is_canceled (boolean)
- is_checked_at (datetime, nullable)

## 🎯 Fitur Utama

### ✅ Validasi QR Code

- QR code unik untuk setiap tiket
- Validasi status: valid / invalid / already used
- Encoding informasi user dan event dalam QR code

### 🎟️ Sistem Reservasi

- Pembatasan jumlah tiket per event
- Pencegahan double booking
- Validasi event yang sudah berakhir

### 🔒 Security

- Token-based authentication (Laravel Sanctum)
- Role-based middleware
- Password hashing
- Input validation

### 📱 API Response Format

Semua response menggunakan format standar:

```json
{
  "status": "Success" | "Error",
  "message": "Description",
  "data": { ... } | null
}
```

## 🚧 Catatan Penting

- ✅ Project ini **hanya API backend** (Part 1)
- ✅ Belum ada implementasi mobile/frontend
- ✅ Menggunakan proper HTTP methods (GET, POST, PATCH, DELETE)
- ✅ Struktur project clean dan terorganisir
- ✅ Dokumentasi lengkap

## 📦 Dependencies Utama

```json
{
    "laravel/framework": "^11.0",
    "laravel/sanctum": "^4.0"
}
```

## 👨‍💻 Author

Proyek ini dibuat sebagai bagian dari SKL #1 - Part 1

## 📄 License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

---

**Note**: Pastikan untuk menjalankan `php artisan migrate` dan `php artisan storage:link` sebelum testing API.
