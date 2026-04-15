<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;

Route::get('/', function () {
    return redirect('/dashboard');
});

Route::get('/dashboard', [DashboardController::class, 'index']);

Route::get('/events', [DashboardController::class, 'events']);
Route::post('/events', [DashboardController::class, 'store'])->name('events.store');
Route::delete('/events/{id}', [DashboardController::class, 'destroy'])->name('events.destroy');

Route::get('/scanner', function () {
    return view('scanner.index');
});
