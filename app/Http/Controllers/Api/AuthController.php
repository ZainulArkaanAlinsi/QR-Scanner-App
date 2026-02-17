<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\ApiResponse;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Laravel\Sanctum\PersonalAccessToken;

    
/**
 * @method \Illuminate\Http\JsonResponse successResponse($data, $message = 'Success', $code = 200)
 * @method \Illuminate\Http\JsonResponse errorResponse($message = 'Error', $code = 400, $data = [])
 */
class AuthController extends Controller
{
    use ApiResponse;

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|confirmed|min:6',
            'role' => 'nullable|in:admin,attendee',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role ?? 'attendee',
        ]);

        
        $data = [
            'token' => $user->createToken('api_token')->plainTextToken,      
            'user' => $user
        ];

        return $this->successResponse($data, 'User registered successfully', 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return $this->errorResponse('User with this email does not exist', 404);
        }

        if (!Hash::check($request->password, $user->password)) {
            return $this->errorResponse('Incorrect password', 401);
        }
        
        
        $data = [
            'token' => $user->createToken('api_token')->plainTextToken,
            'user' => $user
        ];

        return $this->successResponse($data, 'User logged in successfully', 200);
    }

    public function logout(Request $request)
    {
        $token = $request->user()->currentAccessToken();

        if ($token instanceof PersonalAccessToken) {
            $token->delete();
        }

        return $this->successResponse(null, 'Logout success', 200);
    }
}
