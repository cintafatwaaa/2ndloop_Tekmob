import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.fromLTRB(25, 0, 25, 20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(166, 142, 115, 0.9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: "Home",
            index: 0,
            onTap: () => context.go('/menu'),
          ),
          _buildNavItem(
            icon: Icons.shopping_cart,
            label: "Shop",
            index: 1,
            onTap: () => context.go('/menu'), // Navigate to shop section
          ),
          _buildNavItem(
            icon: Icons.store,
            label: "Seller",
            index: 2,
            onTap: () => context.go('/seller'),
          ),
          _buildNavItem(
            icon: Icons.person,
            label: "Profil",
            index: 3,
            onTap: () => context.go('/profil-toko'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? const Color.fromRGBO(129, 120, 120, 1)
                    : Colors.white,
          ),
          Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? const Color.fromRGBO(129, 120, 120, 1)
                      : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
