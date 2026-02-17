<?php

namespace App\Http\Controllers;

use App\ApiResponse;
use App\Models\Event;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;


class EventController extends Controller
{
    use ApiResponse;

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'desc' => 'required|string',
            'images' => 'required|array|min:1',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'date' => 'required|date',
            'max_reservation' => 'required|integer|min:1',
        ]);

        $paths = [];
        if ($request->hasFile('image')) {
            foreach ($request->file('image') as $image) {
                $path = $image->store('events','public');
                $paths[] = Storage::url($path);
            }
        }

        $validated['image'] = $paths;

        $event = Event::create($validated);

        return $this->success($event, 'Event created successfully',201);
    }
}
