import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  static const _items = [
    _NavItem(icon: Icons.home_outlined, label: 'Home', route: '/home'),
    _NavItem(
        icon: Icons.directions_car_outlined,
        label: 'Vehicles',
        route: '/vehicles'),
    _NavItem(
        icon: Icons.calendar_today_outlined,
        label: 'Bookings',
        route: '/bookings'),
    _NavItem(icon: Icons.build_outlined, label: 'Services', route: '/services'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (i) => _NavButton(
                item: _items[i],
                isActive: currentIndex == i,
                onTap: () {
                  if (currentIndex != i) context.go(_items[i].route);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem(
      {required this.icon, required this.label, required this.route});
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton(
      {required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon,
              size: 24,
              color: isActive ? Colors.black : const Color(0xFF9E9E9E)),
          const SizedBox(height: 4),
          Text(item.label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? Colors.black : const Color(0xFF9E9E9E))),
        ],
      ),
    );
  }
}
