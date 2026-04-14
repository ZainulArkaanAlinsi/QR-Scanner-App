<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\Ticket;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    /**
     * Display the bento-style telemetry dashboard.
     */
    public function index()
    {
        $stats = [
            'total_events' => Event::count(),
            'total_tickets' => Ticket::where('is_canceled', false)->count(),
            'checked_in' => Ticket::whereNotNull('check_in_at')->count(),
            'event_velocity' => $this->getEventVelocity(), // Mock logic for visual interest
        ];

        $upcomingEvents = Event::where('date', '>=', now())
            ->orderBy('date', 'asc')
            ->take(3)
            ->get();

        $recentCheckins = Ticket::with(['user', 'event'])
            ->whereNotNull('check_in_at')
            ->orderByDesc('check_in_at')
            ->take(6)
            ->get();

        return view('dashboard', compact('stats', 'upcomingEvents', 'recentCheckins'));
    }

    /**
     * Display the precision event registry.
     */
    public function events()
    {
        $events = Event::withCount(['tickets' => function ($query) {
                $query->where('is_canceled', false);
            }])
            ->latest()
            ->paginate(10);

        return view('events.index', compact('events'));
    }

    /**
     * Helper to simulate "Velocity" for the HUD aesthetics.
     */
    private function getEventVelocity()
    {
        $base = Ticket::where('created_at', '>=', now()->subDays(7))->count();
        return number_format($base / 1000, 1) . 'k';
    }
}
