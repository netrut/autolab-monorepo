import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/service_centre_provider.dart';
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
import '../../features/service_centers/screens/service_centers_screen.dart';
import '../../features/service_centers/screens/add_service_center_screen.dart';
import '../../features/service_centers/screens/service_centre_gateway_screen.dart';
import '../../features/service_centers/screens/team_members_screen.dart';
import '../../features/invoice/screens/invoice_screen.dart';
import '../../features/requests/screens/requests_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider, {ServiceCentreProvider? serviceCentreProvider}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: serviceCentreProvider != null
        ? Listenable.merge([authProvider, serviceCentreProvider])
        : authProvider,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isOnboardRoute = state.matchedLocation == '/service-centers/onboard';
      final isAddCentreRoute = state.matchedLocation == '/service-centers/add';

      if (!isLoggedIn && !isAuthRoute) return '/auth/login';
      if (isLoggedIn && isAuthRoute) return '/home';

      // If logged in but no service centre mapped, redirect to gateway
      // (skip if already on onboard/add/requests/notifications/profile routes)
      if (isLoggedIn && serviceCentreProvider != null && !isOnboardRoute && !isAddCentreRoute) {
        final isRequestsRoute = state.matchedLocation == '/requests';
        final isNotificationsRoute = state.matchedLocation == '/notifications';
        final isProfileRoute = state.matchedLocation == '/profile';
        if (isRequestsRoute || isNotificationsRoute || isProfileRoute) return null;

        if (serviceCentreProvider.initialized && serviceCentreProvider.centres.isEmpty) {
          return '/service-centers/onboard';
        }
      }

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
            builder: (_, state) => AddVehicleScreen(
              initialType: state.uri.queryParameters['type'],
            ),
          ),
          GoRoute(
            path: 'edit/:vehicleId',
            builder: (_, state) => AddVehicleScreen(
              vehicleId: state.pathParameters['vehicleId'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/bookings',
        builder: (_, __) => const BookingsScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (_, state) => CreateBookingScreen(
              initialVehicleId: state.uri.queryParameters['vehicleId'],
            ),
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
      GoRoute(
        path: '/service-centers',
        builder: (_, __) => const ServiceCentersScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (_, __) => const AddServiceCenterScreen(),
          ),
          GoRoute(
            path: 'edit/:centreId',
            builder: (_, state) => AddServiceCenterScreen(
              centreId: state.pathParameters['centreId'],
            ),
          ),
          GoRoute(
            path: ':centreId/team',
            builder: (_, state) => TeamMembersScreen(
              centreId: state.pathParameters['centreId']!,
              centreName: state.uri.queryParameters['name'] ?? 'Service Centre',
              isOwner: state.uri.queryParameters['owner'] == 'true',
            ),
          ),
          GoRoute(
            path: 'onboard',
            builder: (_, __) => const ServiceCentreGatewayScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/invoice/:serviceId',
        builder: (_, state) => InvoiceScreen(
          serviceId: state.pathParameters['serviceId']!,
        ),
      ),
      GoRoute(
        path: '/requests',
        builder: (_, __) => const RequestsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
    ],
  );
}
