<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use Illuminate\Http\Request;
use App\ApiResponse;
use Illuminate\Support\Facades\Storage;


class EventController extends Controller
{
    use ApiResponse;

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'description' => 'required|string',
            'images' => 'required|array|min:1',
            'images.*' => 'image|mimes:jpeg,png,jpg|max:2048',
            'date' => 'required|date',
            'max_reservation' => 'required|integer|min:1',
        ]);

        $imagePaths = [];
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $path = $image->store('events', 'public');
                $imagePaths[] = Storage::url($path);
            }
        }
        $validated['images'] = $imagePaths;
        $event = Event::create($validated);
        return $this->successResponse($event, 'Event created successfully', 201);
    }

    public function index()
    {
        $events = Event::withCount([
            'tickets_count' => function ($query) {
                $query->where('is_canceled', false);
            },
        ]   )->latest()->get();
        return $this->successResponse($events, 'Events retrieved successfully',200 );
    }


    public function show($id)
    {
        $event = Event::withCount([
            'tickets_count' => function ($query) {
                $query->where('is_canceled', false);
            },
        ])->find($id);          

        if (!$event) {
            return $this->errorResponse('Event not found', 404);
        }

        return $this->successResponse($event, 'Event retrieved successfully',200);
    }

    public function update(Request $request, $eventId)
    {
        $event = Event::find($eventId);

        if (!$event) {
            return $this->errorResponse('Event not found', 404);
        }

        // ... validation ...

        $validated = $request->validate([
            'name' => 'sometimes|required|string',
            'description' => 'sometimes|required|string',
            'images' => 'nullable|array|min:1',
            'images.*' => 'image|mimes:jpeg,png,jpg|max:2048',
            'date' => 'sometimes|required|date',
            'max_reservation' => 'sometimes|required|integer|min:1',
        ]);

        if ($request->hasFile('images')) {
            $imagePaths = [];
            foreach ($request->file('images') as $image) {
                $path = $image->store('events', 'public');
                $imagePaths[] = Storage::url($path);
            }
            
            // Delete old files
            if ($event->images) {
                foreach ($event->images as $image) {
                    // Extract relative path from URL (remove /storage/)
                    $relativePath = str_replace('/storage/', '', parse_url($image, PHP_URL_PATH));
                    Storage::disk('public')->delete($relativePath);
                }
            }
            
            $validated['images'] = $imagePaths;
        }

        /** @var \App\Models\Event $event */
        $event->update($validated);
        
        return $this->successResponse($event, 'Event updated successfully', 200);
    }

    public function delete($eventId)
    {
        $event = Event::find($eventId);

        if (!$event) {
            return $this->errorResponse('Event not found', 404);
        }

        if ($event->images) {
            foreach ($event->images as $image) {
                // Extract relative path from URL (remove /storage/)
                // Use parse_url to handle full URLs if present
                $path = parse_url($image, PHP_URL_PATH);
                $relativePath = str_replace('/storage/', '', $path);
                Storage::disk('public')->delete($relativePath);
            }
        }   

        /** @var \App\Models\Event $event */
        $event->delete();
        
        return $this->successResponse(null, 'Event deleted successfully', 200);
    }
}
