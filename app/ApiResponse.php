<?php

namespace App;

use GrahamCampbell\ResultType\Success;
use Illuminate\Http\JsonResponse;

trait ApiResponse
{
    // Success Response 
    protected function successResponse($data, $message = 'Success', $code = 200)
    {
        return response()->json([
            'status' => 'Success',
            'message' => $message,
            'data' => $data,
        ], $code);
    }

    protected function success($data, $message = 'Success', $code = 200)
    {
        return $this->successResponse($data, $message, $code);
    }
    
    // Error Response 
    protected function errorResponse($message = 'Error', $code = 400, $data = null)
    {
        return response()->json([
            'status' => 'Error',
            'message' => $message,
            'data' => $data,
        ], $code);
    }

    protected function error($message = 'Error', $code = 400, $data = null)
    {
        return $this->errorResponse($message, $code, $data);
    }
    
}
