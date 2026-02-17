<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\EventController;
use App\Http\Controllers\Api\TicketController;
use App\Http\Middleware\RoleMiddleware;


// Public Routes
Route::group([],function(   ){
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login'])->name('login');
});

// Protected Routes
Route::middleware('auth:sanctum')->group(function () {
    // Get User Profile
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Logout
    Route::post('/logout', [AuthController::class, 'logout']);
    // Event Details
    Route::get('/event/{eventId}', [EventController::class, 'show']);
    // Event Index
    Route::get('/event', [EventController::class, 'index']);


    // Attendance Only
    Route::group(['middleware' => ['role:attendee']], function () {
        // Reserve Ticket
         Route::post('/event/{eventId}/reserve', [TicketController::class, 'store']);
         //  My Ticket List
         Route::get('/my-tickets', [TicketController::class, 'indexByUser']);   
         // Cancel Ticket
         Route::patch('/ticket/{ticketId}/cancel', [TicketController::class, 'cancel']);
    });
 
    

    // Admin Only
    Route::middleware('role:admin')->group(function () {
        Route::post('/event', [EventController::class, 'store']);
        Route::post('/event/{eventId}', [EventController::class, 'update']);
        Route::delete('/event/{eventId}', [EventController::class, 'delete']);
        Route::get('/event/{eventId}/ticket', [TicketController::class, 'indexByEvent']);
        Route::patch('/ticket/{ticketId}/checkin', [TicketController::class, 'checkin']);
    });
});
