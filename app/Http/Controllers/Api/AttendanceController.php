<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use Illuminate\Http\Request;
use App\ApiResponse;

class AttendanceController extends Controller
{
    use ApiResponse;

    public function index()
    {
        $attendances = Attendance::with(['user', 'event'])->get();
        return $this->success($attendances, 'Attendance retrieved successfully', 200);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'event_id' => 'required|exists:events,id',
            'status' => 'required|string',
        ]);

        $attendance = Attendance::create($validated);

        return $this->success($attendance, 'Attendance recorded successfully', 201);
    }

    public function show($id)
    {
        $attendance = Attendance::with(['user', 'event'])->find($id);

        if (!$attendance) {
            return $this->errorResponse('Attendance not found', 404);
        }

        return $this->success($attendance, 'Attendance data retrieved', 200);
    }

    public function update(Request $request, $id)
    {
        $attendance = Attendance::find($id);

        if (!$attendance) {
            return $this->errorResponse('Attendance not found', 404);
        }

        $validated = $request->validate([
            'status' => 'sometimes|string',
        ]);

        /** @var \App\Models\Attendance $attendance */
        $attendance->update($validated);

        return $this->success($attendance, 'Attendance updated successfully', 200);
    }

    public function destroy($id)
    {
        $attendance = Attendance::find($id);

        if (!$attendance) {
            return $this->errorResponse('Attendance not found', 404);
        }

        /** @var \App\Models\Attendance $attendance */
        $attendance->delete();

        return $this->success(null, 'Attendance deleted successfully', 200);
    }
}
