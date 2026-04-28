import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }

    switch (index) {
      case 0:
        context.goNamed(HomeWidget.routeName);
        break;
      case 1:
        context.goNamed(AddNewWidget.routeName);
        break;
      case 2:
        context.goNamed(SearchWidget.routeName);
        break;
      case 3:
        context.goNamed(ProfileWidget.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFFF8F8F8),
      elevation: 6.0,
      selectedItemColor: Color(0xFF1F1F1F),
      unselectedItemColor: Color(0xFF7A7A7A),
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
      ),
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car_rounded),
          label: 'Vehicles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
