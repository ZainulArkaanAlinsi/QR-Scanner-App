<?php

use App\Http\Controllers\DashboardController;

Route::get('/', function () {
    return redirect('/dashboard');
});

Route::get('/dashboard', [DashboardController::class, 'index']);

Route::get('/events', [DashboardController::class, 'events']);

Route::get('/scanner', function () {
    return view('scanner.index');
});
