import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/ticket_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/my_tickets_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/event_form_screen.dart';

import 'core/themes/app_theme.dart';
import 'core/utils/const.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/event/:id',
      builder: (_, state) =>
          EventDetailScreen(eventId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/my-tickets', builder: (_, __) => const MyTicketsScreen()),
    GoRoute(path: '/scanner', builder: (_, __) => const QrScannerScreen()),
    GoRoute(
        path: '/events/create', builder: (_, __) => const EventFormScreen()),
    GoRoute(
      path: '/events/edit/:id',
      builder: (_, state) =>
          EventFormScreen(eventId: state.pathParameters['id']),
    ),
  ],
);

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
      ],
      child: MaterialApp.router(
        title: Const.appName,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
