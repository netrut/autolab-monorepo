import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/vehicle_provider.dart';
import 'core/providers/booking_provider.dart';
import 'core/providers/vehicle_service_provider.dart';
import 'core/utils/router.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
