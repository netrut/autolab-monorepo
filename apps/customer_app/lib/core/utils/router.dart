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
import '../../features/vehicles/screens/vehicle_detail_screen.dart';
import '../../features/bookings/screens/bookings_screen.dart';
import '../../features/bookings/screens/create_booking_screen.dart';
import '../../features/bookings/screens/booking_detail_screen.dart';
import '../../features/service_history/screens/service_history_screen.dart';
import '../../features/service_history/screens/service_detail_screen.dart';
import '../../features/invoices/screens/invoices_screen.dart';
import '../../features/invoices/screens/invoice_detail_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/search/screens/service_centre_detail_screen.dart';
import '../../features/requests/screens/requests_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

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
      // Auth
      GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/auth/otp',
        builder: (_, state) => OtpScreen(phone: state.uri.queryParameters['phone'] ?? ''),
      ),
      GoRoute(path: '/auth/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),

      // Home
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),

      // Vehicles
      GoRoute(
        path: '/vehicles',
        builder: (_, __) => const VehiclesScreen(),
        routes: [
          GoRoute(path: 'add', builder: (_, state) => AddVehicleScreen(initialType: state.uri.queryParameters['type'])),
          GoRoute(path: 'edit/:vehicleId', builder: (_, state) => AddVehicleScreen(vehicleId: state.pathParameters['vehicleId'])),
          GoRoute(path: ':vehicleId', builder: (_, state) => VehicleDetailScreen(vehicleId: state.pathParameters['vehicleId']!)),
        ],
      ),

      // Bookings
      GoRoute(
        path: '/bookings',
        builder: (_, __) => const BookingsScreen(),
        routes: [
          GoRoute(path: 'create', builder: (_, state) => CreateBookingScreen(initialVehicleId: state.uri.queryParameters['vehicleId'])),
          GoRoute(path: ':bookingId', builder: (_, state) => BookingDetailScreen(bookingId: state.pathParameters['bookingId']!)),
        ],
      ),

      // Service History
      GoRoute(path: '/service-history', builder: (_, __) => const ServiceHistoryScreen()),
      GoRoute(path: '/service-detail/:serviceId', builder: (_, state) => ServiceDetailScreen(serviceId: state.pathParameters['serviceId']!)),

      // Invoices
      GoRoute(path: '/invoices', builder: (_, __) => const InvoicesScreen()),
      GoRoute(path: '/invoices/:id', builder: (_, state) => InvoiceDetailScreen(invoiceId: state.pathParameters['id']!)),

      // Search Service Centres
      GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
      GoRoute(path: '/search/:centreId', builder: (_, state) => ServiceCentreDetailScreen(centreId: state.pathParameters['centreId']!)),

      // Requests, Notifications, Profile, Settings
      GoRoute(path: '/requests', builder: (_, __) => const RequestsScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
}
