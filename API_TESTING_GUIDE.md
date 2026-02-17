# API Testing Guide

## Quick Start

### Setup

1. Start server: `php artisan serve`
2. Base URL: `http://localhost:8000/api`
3. Use Postman, Thunder Client, or curl

## Testing Flow

### Step 1: Register Admin

**Request:**

```http
POST http://localhost:8000/api/register
Content-Type: application/json

{
  "name": "Admin User",
  "email": "admin@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "role": "admin"
}
```

**Expected Response (201):**

```json
{
  "status": "Success",
  "message": "User registered successfully",
  "data": {
    "token": "1|abc123...",
    "user": {
      "id": "01JQWE...",
      "name": "Admin User",
      "email": "admin@example.com",
      "role": "admin"
    }
  }
}
```

Save the token for admin operations.

### Step 2: Register Attendee

**Request:**

```http
POST http://localhost:8000/api/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Expected Response (201):**

```json
{
  "status": "Success",
  "message": "User registered successfully",
  "data": {
    "token": "2|xyz789...",
    "user": {
      "id": "01JQWF...",
      "name": "John Doe",
      "email": "john@example.com",
      "role": "attendee"
    }
  }
}
```

Save this token for attendee operations.

### Step 3: Create Event (as Admin)

**Request:**

```http
POST http://localhost:8000/api/event
Authorization: Bearer {admin_token}
Content-Type: multipart/form-data

name: Tech Conference 2026
description: Annual technology conference
date: 2026-03-15 09:00:00
max_reservation: 100
images[]: [select image file]
```

**Expected Response (201):**

```json
{
  "status": "Success",
  "message": "Event created successfully",
  "data": {
    "id": "01JQWG...",
    "name": "Tech Conference 2026",
    "description": "Annual technology conference",
    "images": ["/storage/events/abc123.jpg"],
    "date": "2026-03-15T09:00:00.000000Z",
    "max_reservation": 100
  }
}
```

Save the event ID.

### Step 4: Reserve Ticket (as Attendee)

**Request:**

```http
POST http://localhost:8000/api/event/{event_id}/reserve
Authorization: Bearer {attendee_token}
```

**Expected Response (201):**

```json
{
  "status": "Success",
  "message": "Ticket created successfully",
  "data": {
    "id": "01JQWH...",
    "code": "ikutan-65d8f9a1b2c3d-eyJ1biI6IjAxSlFXRi4uLiIsInVlIjoiam9obkBleGFtcGxlLmNvbSIsImVuIjoiVGVjaCBDb25mZXJlbmNlIDIwMjYiLCJlZCI6IjIwMjYtMDMtMTVUMDk6MDA6MDAuMDAwMDAwWiJ9",
    "is_canceled": false,
    "check_in_at": null
  }
}
```

Copy the QR code (the "code" field).

### Step 5: Check-in Ticket (as Admin) - QR CODE VALIDATION

**Request:**

```http
PATCH http://localhost:8000/api/ticket/{ticket_id}/checkin
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "code": "ikutan-65d8f9a1b2c3d-eyJ1biI6IjAxSlFXRi4uLiIsInVlIjoiam9obkBleGFtcGxlLmNvbSIsImVuIjoiVGVjaCBDb25mZXJlbmNlIDIwMjYiLCJlZCI6IjIwMjYtMDMtMTVUMDk6MDA6MDAuMDAwMDAwWiJ9"
}
```

**Expected Response (200) - VALID:**

```json
{
  "status": "Success",
  "message": "Ticket checked in successfully",
  "data": {
    "id": "01JQWH...",
    "code": "ikutan-65d8f9a1b2c3d-...",
    "check_in_at": "2026-02-17T10:30:00.000000Z"
  }
}
```

### Step 6: Try Check-in Again (Should Fail - Already Used)

**Request:**

```http
PATCH http://localhost:8000/api/ticket/{ticket_id}/checkin
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "code": "ikutan-65d8f9a1b2c3d-..."
}
```

**Expected Response (400) - ALREADY USED:**

```json
{
  "status": "Error",
  "message": "Ticket already checked in",
  "data": null
}
```

### Step 7: Try Invalid QR Code (Should Fail)

**Request:**

```http
PATCH http://localhost:8000/api/ticket/{ticket_id}/checkin
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "code": "invalid-qr-code-12345"
}
```

**Expected Response (404) - INVALID:**

```json
{
  "status": "Error",
  "message": "Ticket not found",
  "data": null
}
```

## Test Checklist

### Authentication Tests

- [ ] Register with valid data → 201
- [ ] Login with valid credentials → 200
- [ ] Login with wrong password → 401
- [ ] Access protected route without token → 401
- [ ] Logout → 200

### Event Tests (Admin)

- [ ] Create event with images → 201
- [ ] Get all events → 200
- [ ] Get single event → 200
- [ ] Update event → 200
- [ ] Delete event → 200

### Ticket Tests (Attendee)

- [ ] Reserve ticket → 201
- [ ] Reserve duplicate ticket → 400
- [ ] Get my tickets → 200
- [ ] Cancel ticket → 200

### QR Code Validation Tests (Admin)

- [ ] Check-in with valid code → 200 ✅ VALID
- [ ] Check-in with invalid code → 404 ✅ INVALID
- [ ] Check-in already used ticket → 400 ✅ ALREADY USED
- [ ] Check-in canceled ticket → 400

## Expected Results Summary

| Test Case | Expected Status | Expected Message |
| --- | --- | --- |
| Valid QR Code | 200 | Ticket checked in successfully |
| Invalid QR Code | 404 | Ticket not found |
| Already Used QR | 400 | Ticket already checked in |
| Canceled Ticket | 400 | Ticket is canceled |
| No Auth Token | 401 | Unauthenticated |
| Wrong Role | 403 | Forbidden |

## Core Requirement Verification

### Validate QR codes

- Endpoint: `PATCH /api/ticket/{ticketId}/checkin`
- Input: QR code string
- Process: Check if code exists and is valid

### Return appropriate responses

- **Valid**: 200 with success message
- **Invalid**: 404 with error message
- **Already used**: 400 with error message

### Use proper HTTP methods

- GET: Read operations
- POST: Create operations
- PATCH: Update operations
- DELETE: Delete operations

### Use proper status codes

- 200: Success
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found

---

**All tests passed? ✅ Ready to submit!**
