import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({
    super.key,
    required this.navigationShell,
    required this.isLogin,
  });

  final StatefulNavigationShell navigationShell;
  final bool isLogin;

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: widget.navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: AppColors.primaryOrange.withValues(alpha: 0.12),
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
              states,
            ) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primaryOrange : AppColors.textGrey,
              );
            }),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: AppColors.textGrey),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: AppColors.primaryOrange,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.assignment_outlined,
                  color: AppColors.textGrey,
                ),
                selectedIcon: Icon(
                  Icons.assignment_rounded,
                  color: AppColors.primaryOrange,
                ),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.textGrey,
                ),
                selectedIcon: Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.primaryOrange,
                ),
                label: 'Earnings',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textGrey,
                ),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryOrange,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
