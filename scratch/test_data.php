<?php

use App\Models\Event;
use App\Models\User;
use App\Models\Ticket;

// 1. Create Event
$event = Event::create([
    'name' => 'Cyber Security Expo 2026',
    'description' => 'A premier security event for tech enthusiasts. Join us for a day of hacking and innovation.',
    'date' => now()->addDays(30),
    'max_reservation' => 500,
    'images' => ['https://images.unsplash.com/photo-1550751827-4bd374c3f58b']
]);

echo "Event Created: " . $event->name . " (" . $event->id . ")\n";

// 2. Identify/Create User
$user = User::where('email', 'admin@gmail.com')->first();
if (!$user) {
    $user = User::first();
}

// 3. Create Ticket
$ticket = Ticket::create([
    'user_id' => $user->id,
    'event_id' => $event->id,
    'code' => 'ikutan-' . uniqid(),
    'is_canceled' => false
]);

echo "Ticket Generated for " . $user->name . ": " . $ticket->code . "\n";
echo "Testing complete.\n";
