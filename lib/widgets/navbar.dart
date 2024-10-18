import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key, 
    required this.selectedIndex, 
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      height: 60,
      indicatorColor: Color(0xFFFB8C2B),
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.explore,
            color: Colors.white,
          ),
          icon: Icon(Icons.explore),
          label: 'Transaction',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.chat,
            color: Colors.white,
          ),
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.show_chart,
            color: Colors.white,
          ),
          icon: Icon(Icons.show_chart),
          label: 'Visualization', // New tab for visualization
        ),
      ],
    );
  }
}
