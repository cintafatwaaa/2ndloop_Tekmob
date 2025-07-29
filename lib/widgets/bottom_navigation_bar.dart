import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final String userRole;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(25, 0, 25, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFA68E73).withOpacity(0.9),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home,
            label: 'Home',
            index: 0,
            route: '/menu',
          ),
          _buildNavItem(
            context,
            icon: Icons.shopping_cart,
            label: 'Shop',
            index: 1,
            route: '/shop',
          ),
          if (userRole == 'seller') ...[
            _buildNavItem(
              context,
              icon: Icons.add_business,
              label: 'Sell',
              index: 2,
              route: '/seller',
            ),
            _buildNavItem(
              context,
              icon: Icons.store,
              label: 'Toko',
              index: 3,
              route: '/profil-toko',
            ),
          ] else ...[
            _buildNavItem(
              context,
              icon: Icons.receipt,
              label: 'Orders',
              index: 2,
              route: '/pesanan',
            ),
            _buildNavItem(
              context,
              icon: Icons.person,
              label: 'Profile',
              index: 3,
              route: '/profil',
            ),
          ],
          if (userRole == 'admin') ...[
            _buildNavItem(
              context,
              icon: Icons.admin_panel_settings,
              label: 'Admin',
              index: 4,
              route: '/profil-admin',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required String route,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
