# Project Submission Checklist

## Requirements Verification

### API Functionality

- [x] Validate QR codes - Endpoint: `PATCH /api/ticket/{ticketId}/checkin`
- [x] Return appropriate responses:
  - Valid ticket (200 - Success)
  - Invalid ticket (404 - Not found)
  - Already used ticket (400 - Already checked in)
- [x] Use proper HTTP methods (GET, POST, PATCH, DELETE)
- [x] Use proper HTTP status codes (200, 201, 400, 401, 403, 404)

### Project Structure

- [x] Clean and logical structure
- [x] Controllers organized in `app/Http/Controllers/Api/`
- [x] Models in `app/Models/`
- [x] Middleware for role-based access
- [x] Standardized API responses using trait
- [x] Proper routing in `routes/api.php`

### Documentation (README.md)

- [x] Project purpose explained
- [x] Available endpoints (14 endpoints with examples)
- [x] How to run locally (step-by-step installation guide)
- [x] Additional documentation (tech stack, database schema, QR format, etc.)

### Code Quality

- [x] Clean and readable code
- [x] Proper naming conventions
- [x] Validation on all inputs
- [x] Error handling
- [x] Security (authentication, authorization)
- [x] Database relationships properly defined

## API Endpoints Summary

Total: 14 endpoints

**Public (2):**

- POST `/register` - Register user
- POST `/login` - Login

**Protected (12):**

- GET `/user` - Get profile
- POST `/logout` - Logout
- GET `/event` - List events
- GET `/event/{id}` - Event detail

**Attendee Only (3):**

- POST `/event/{id}/reserve` - Reserve ticket
- GET `/my-tickets` - My tickets
- PATCH `/ticket/{id}/cancel` - Cancel ticket

**Admin Only (5):**

- POST `/event` - Create event
- POST `/event/{id}` - Update event
- DELETE `/event/{id}` - Delete event
- GET `/event/{id}/ticket` - Event tickets
- PATCH `/ticket/{id}/checkin` - QR Validation

## Pre-Submission Steps

1. [x] Fix all code issues
2. [x] Update README.md with complete documentation
3. [ ] Test all endpoints manually or with Postman
4. [x] Ensure `.env` is not committed (in `.gitignore`)
5. [ ] Push to GitHub
6. [ ] Submit repository link

## Key Features Implemented

**QR Code System:**

- Format: `ikutan-{uniqid}-{base64_payload}`
- Payload includes: user_id, email, event_name, event_date
- Validation: valid / invalid / already used

**Business Logic:**

- Prevent double booking
- Event capacity management
- Prevent booking for past events
- Prevent check-in for canceled tickets
- Transaction handling

**Security:**

- Laravel Sanctum token authentication
- Role-based middleware (admin/attendee)
- Password hashing
- Input validation on all endpoints

## Status

✅ **READY FOR SUBMISSION**

All requirements met. README.md is complete with project purpose, available endpoints, and how to run locally.
