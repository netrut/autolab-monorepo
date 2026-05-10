import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/vehicles/screens/vehicles_screen.dart';
import '../../features/vehicles/screens/add_vehicle_screen.dart';
import '../../features/bookings/screens/bookings_screen.dart';
import '../../features/bookings/screens/create_booking_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/service/screens/service_screen.dart';
import '../../features/service/screens/service_form_screen.dart';
import '../../features/service/screens/service_history_screen.dart';
import '../../features/service/screens/service_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isLoggedIn && !isAuthRoute) return '/auth/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      // ── Auth routes ──────────────────────────────────────────────────────
      GoRoute(
        path: '/auth/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),

      // ── App routes ───────────────────────────────────────────────────────
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/vehicles',
        builder: (_, __) => const VehiclesScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (_, __) => const AddVehicleScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/bookings',
        builder: (_, __) => const BookingsScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (_, __) => const CreateBookingScreen(),
          ),
        ],
      ),

      // ── Service routes ───────────────────────────────────────────────────
      GoRoute(
        path: '/services',
        builder: (_, __) => const ServiceScreen(),
      ),
      GoRoute(
        path: '/service/form/:vehicleId',
        builder: (_, state) {
          final vehicleId = state.pathParameters['vehicleId']!;
          final serviceId = state.uri.queryParameters['serviceId'];
          return ServiceFormScreen(vehicleId: vehicleId, serviceId: serviceId);
        },
      ),
      GoRoute(
        path: '/service/history/:vehicleId',
        builder: (_, state) => ServiceHistoryScreen(
          vehicleId: state.pathParameters['vehicleId']!,
        ),
      ),
      GoRoute(
        path: '/service/detail/:serviceId',
        builder: (_, state) => ServiceDetailScreen(
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),

      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
    ],
  );
}
