import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';

class ActiveOrdersScreen extends StatelessWidget {
  const ActiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Ambient soft green curve on top left
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.acceptGreen.withValues(alpha: 0.16),
                    AppColors.acceptGreen.withValues(alpha: 0.05),
                    AppColors.acceptGreen.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. App Bar
                ActiveOrdersAppBar(
                  activeCount: '1 Active Order',
                  onBackTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.mainDashboard);
                    }
                  },
                  onNotificationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('1 Active Delivery in Progress'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColors.textColor,
                        duration: const Duration(milliseconds: 1000),
                      ),
                    );
                  },
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    child: Column(
                      children: [
                        // 2. Active Order Header Card
                        const ActiveOrderHeaderCard(),

                        const SizedBox(height: 12),

                        // 3. Delivery Progress Stepper
                        const DeliveryProgressCard(),

                        const SizedBox(height: 12),

                        // 4. Live Map Container with Estimated Time Pill
                        const ActiveOrderLiveMap(),

                        const SizedBox(height: 12),

                        // 5. Action Buttons Grid (2x2)
                        ActionButtonsGrid(
                          onViewDetails: () {
                            context.pushNamed(AppRoutes.orderDetails);
                          },
                          onNavigate: () {
                            context.pushNamed(AppRoutes.deliveryDetails);
                          },
                          onContactSeller: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Calling ABC Store (+91 98765 43210)...',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: AppColors.textColor,
                                duration: const Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          onContactCustomer: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Calling Customer Priya Sharma (+91 98765 43210)...',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: AppColors.textColor,
                                duration: const Duration(milliseconds: 1000),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // 6. Main Action Button: Continue Delivery
                        ContinueDeliveryButton(
                          onContinueTap: () {
                            context.pushNamed(AppRoutes.deliveryDetails);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 1. App Bar
// =============================================================================
class ActiveOrdersAppBar extends StatelessWidget {
  final String activeCount;
  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;

  const ActiveOrdersAppBar({
    super.key,
    required this.activeCount,
    required this.onBackTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderGrey, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textColor,
              ),
            ),
          ),

          // Title & Count Subtitle
          Column(
            children: [
              const Text(
                'Active Orders',
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '($activeCount)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),

          // Notification Bell with Badge '1'
          GestureDetector(
            onTap: onNotificationTap,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 26,
                    color: AppColors.textColor,
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(
                        color: AppColors.rejectRed,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 2. Active Order Header Card
// =============================================================================
class ActiveOrderHeaderCard extends StatelessWidget {
  const ActiveOrderHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store graphic
              _buildStoreGraphic(),

              const SizedBox(width: 12),

              // Order details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '#SVN10245',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.paidGreenBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'In Progress',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.acceptGreen,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Timestamp
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '03 Nov 2026 • 10:15 AM',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Store
                    Row(
                      children: const [
                        Icon(
                          Icons.storefront_outlined,
                          size: 14,
                          color: AppColors.textColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'ABC Store',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Customer
                    Row(
                      children: const [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: AppColors.textColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Priya Sharma',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
           Divider(color: AppColors.borderGrey, height: 1),
          const SizedBox(height: 10),

          // Bottom Stats: 4.5 km Remaining | ₹85.00 Earnings
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.navigation_outlined,
                      size: 15,
                      color: AppColors.acceptGreen,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '4.5 km',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'Remaining',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(width: 1, height: 26, color: AppColors.borderGrey),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.currency_rupee_rounded,
                      size: 16,
                      color: AppColors.acceptGreen,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '₹85.00',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.acceptGreen,
                          ),
                        ),
                        Text(
                          'Earnings',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreGraphic() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.lightPeachBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightOrangeBorder),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'ABC STORE',
              style: TextStyle(
                fontSize: 6.5,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Container(
                width: 7,
                height: 5,
                decoration: BoxDecoration(
                  color: i.isEven ? AppColors.primaryOrange : AppColors.white,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 28,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: AppColors.borderGrey),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 3. Delivery Progress Stepper
// =============================================================================
class DeliveryProgressCard extends StatelessWidget {
  const DeliveryProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Progress',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textColor,
            ),
          ),

          const SizedBox(height: 16),

          // 5-step horizontal stepper:
          // 1. Accepted (check)
          // 2. Reached Pickup (check)
          // 3. Picked Up (check)
          // 4. Heading to Customer (orange dot)
          // 5. Delivered (grey dot)
          Row(
            children: [
              _buildStepNode(isDone: true, label: 'Accepted'),
              _buildLine(isDone: true),
              _buildStepNode(isDone: true, label: 'Reached\nPickup'),
              _buildLine(isDone: true),
              _buildStepNode(isDone: true, label: 'Picked Up'),
              _buildLine(isDone: true),
              _buildStepNode(isActive: true, label: 'Heading to\nCustomer'),
              _buildLine(isDone: false),
              _buildStepNode(isDone: false, label: 'Delivered'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode({
    bool isDone = false,
    bool isActive = false,
    required String label,
  }) {
    Color bg;
    Widget icon;

    if (isDone) {
      bg = AppColors.acceptGreen;
      icon = const Icon(Icons.check, size: 12, color: AppColors.white);
    } else if (isActive) {
      bg = AppColors.primaryOrange;
      icon = const Icon(Icons.two_wheeler_rounded, size: 12, color: AppColors.white);
    } else {
      bg = AppColors.borderGrey;
      icon = Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: icon,
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 48,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: (isDone || isActive) ? FontWeight.w700 : FontWeight.w500,
              color: (isDone || isActive) ? AppColors.textColor : AppColors.textGrey,
              height: 1.15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 2.5,
        margin: const EdgeInsets.only(bottom: 24),
        color: isDone ? AppColors.acceptGreen : AppColors.borderGrey,
      ),
    );
  }
}

// =============================================================================
// 4. Live Map Container with Estimated Time Pill
// =============================================================================
class ActiveOrderLiveMap extends StatelessWidget {
  const ActiveOrderLiveMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Background Map Painter
            Positioned.fill(
              child: CustomPaint(
                painter: ActiveRouteMapPainter(),
              ),
            ),

            // Pickup Store Marker on Left
            Positioned(
              left: 20,
              top: 50,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.acceptGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ),

            // Scooter Delivery Partner navigating on route
            Positioned(
              left: 140,
              top: 56,
              child: Image.asset(
                AppImages.deliveryBikeP,
                width: 50,
                height: 42,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.two_wheeler_rounded,
                  color: AppColors.primaryOrange,
                  size: 32,
                ),
              ),
            ),

            // Customer Destination Marker on Right
            Positioned(
              right: 20,
              top: 56,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ),

            // Floating Bottom Pill: Est. Delivery Time: 10:45 AM (≈ 15 min)
            Positioned(
              left: 20,
              right: 20,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderGrey),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Est. Delivery Time: ',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      '10:45 AM (≈ 15 min)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveRouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background canvas
    final bgPaint = Paint()..color = AppColors.primaryOrange;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Green areas / parks
    final greenPaint = Paint()..color = AppColors.primaryOrange;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, 10, 80, 45),
        const Radius.circular(8),
      ),
      greenPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.65, size.height * 0.45, 95, 50),
        const Radius.circular(8),
      ),
      greenPaint,
    );

    // Light blue water curve
    final waterPaint = Paint()..color = AppColors.primaryOrange;
    final waterPath = Path()
      ..moveTo(size.width * 0.7, size.height)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Street network
    final roadPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 3.5;

    canvas.drawLine(Offset(0, 70), Offset(size.width, 85), roadPaint);
    canvas.drawLine(Offset(0, 130), Offset(size.width, 135), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.35, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(size.width * 0.8, size.height), roadPaint);

    // Green route path
    final routePaint = Paint()
      ..color = AppColors.acceptGreen
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePath = Path()
      ..moveTo(34, 64)
      ..lineTo(80, 76)
      ..lineTo(140, 70)
      ..lineTo(size.width - 90, 84)
      ..lineTo(size.width - 34, 70);

    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// 5. Action Buttons Grid (2x2)
// =============================================================================
class ActionButtonsGrid extends StatelessWidget {
  final VoidCallback onViewDetails;
  final VoidCallback onNavigate;
  final VoidCallback onContactSeller;
  final VoidCallback onContactCustomer;

  const ActionButtonsGrid({
    super.key,
    required this.onViewDetails,
    required this.onNavigate,
    required this.onContactSeller,
    required this.onContactCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildOutlineButton(
                icon: Icons.visibility_outlined,
                label: 'View Details',
                onTap: onViewDetails,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildOutlineButton(
                icon: Icons.near_me_outlined,
                label: 'Navigate',
                onTap: onNavigate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildOutlineButton(
                icon: Icons.phone_outlined,
                label: 'Contact Seller',
                onTap: onContactSeller,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildOutlineButton(
                icon: Icons.phone_outlined,
                label: 'Contact Customer',
                onTap: onContactCustomer,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: AppColors.borderGrey, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 6. Main Action Button: Continue Delivery
// =============================================================================
class ContinueDeliveryButton extends StatelessWidget {
  final VoidCallback onContinueTap;

  const ContinueDeliveryButton({super.key, required this.onContinueTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onContinueTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.acceptGreen,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.acceptGreen.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Continue Delivery',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

