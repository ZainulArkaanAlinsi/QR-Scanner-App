<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Validation\ValidationException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;


return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'role' => \App\Http\Middleware\RoleMiddleware::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (Throwable $e, Request $request) {
            if ($request->is('api/*')) {

                // Handle Validasi Error
                if ($e instanceof ValidationException) {
                    return response()->json([
                        'status' => 'Error',
                        'message' => 'Validasi Error',
                        'errors' => $e->errors(),
                    ], 422);
                }

                // Handle Authentication Exceptions
                if ($e instanceof AuthenticationException) {
                    return response()->json([
                        'status' => 'Error',
                        'message' => 'Authentication Error',
                        'errors' => [],
                    ], 401);
                }

                // Handle Model Not Found Exceptions
                if ($e instanceof ModelNotFoundException) {
                    return response()->json([
                        'status' => 'Error',
                        'message' => 'Resource Not Found',
                        'errors' => [],
                    ], 404);
                }

                // Determine Status Code
                $statusCode = 500;
                if ($e instanceof HttpExceptionInterface) {
                    $statusCode = $e->getStatusCode();
                }

                // Determine Message
                $message = $e->getMessage();
                if (empty($message)) {
                    $message = match ($statusCode) {
                        401 => 'Unauthorized',
                        403 => 'Forbidden',
                        404 => 'Resource Not Found',
                        405 => 'Method Not Allowed',
                        default => 'Internal Server Error',
                    };
                }

                // Fallback to 500
                return response()->json([
                    'status' => 'Error',
                    'message' => $message,
                    'errors' => [],
                ], $statusCode);
            }
        });
    })->create();
