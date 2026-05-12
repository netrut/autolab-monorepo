import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/vehicle_provider.dart';
import 'core/providers/booking_provider.dart';
import 'core/providers/vehicle_service_provider.dart';
import 'core/providers/options_provider.dart';
import 'core/providers/request_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/providers/service_centre_provider.dart';
import 'core/utils/router.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Disable runtime HTTP font fetching — fonts must be bundled as assets.
  // This fixes missing icons and Noto font warnings on Vercel web deployment.
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const AutoLabApp());
}

class AutoLabApp extends StatelessWidget {
  const AutoLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => VehicleServiceProvider()),
        ChangeNotifierProvider(create: (_) => OptionsProvider()..init()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ServiceCentreProvider()),
      ],
      child: const _AppRouter(),
    );
  }
}

class _AppRouter extends StatefulWidget {
  const _AppRouter();

  @override
  State<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<_AppRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _router = createRouter(auth);
    // Init service centre switcher after auth resolves
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.isLoggedIn) {
        context.read<ServiceCentreProvider>().init();
      }
      // Re-init whenever login state changes
      auth.addListener(() {
        if (auth.isLoggedIn) {
          context.read<ServiceCentreProvider>().init();
        } else {
          context.read<ServiceCentreProvider>().clear();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AutoLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
