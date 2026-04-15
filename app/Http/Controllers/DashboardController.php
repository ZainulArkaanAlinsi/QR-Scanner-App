<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\Ticket;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

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
     * Store a new event manifest.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'date' => 'required|date|after_or_equal:today',
            'max_reservation' => 'required|integer|min:1',
            'images' => 'required|array|min:1',
            'images.*' => 'image|mimes:jpeg,png,jpg|max:5000',
        ]);

        $imagePaths = [];
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $path = $image->store('events', 'public');
                $imagePaths[] = asset('storage/' . $path);
            }
        }
        
        $validated['images'] = $imagePaths;

        Event::create($validated);

        return redirect()->back()->with('success', 'MANIFEST_DEPLOYED_SUCCESSFULLY');
    }

    /**
     * Decommission an event manifest.
     */
    public function destroy($id)
    {
        $event = Event::findOrFail($id);

        // Delete images from storage
        if ($event->images) {
            foreach ($event->images as $image) {
                $path = parse_url($image, PHP_URL_PATH);
                $relativePath = str_replace('/storage/', '', $path);
                Storage::disk('public')->delete($relativePath);
            }
        }

        $event->delete();

        return redirect()->back()->with('success', 'MANIFEST_DECOMMISSIONED_SUCCESSFULLY');
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
