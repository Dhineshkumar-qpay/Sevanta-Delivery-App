import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

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
                OrderDetailAppBar(
                  orderId: '#SVN10245',
                  onBackTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.mainDashboard);
                    }
                  },
                ),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    child: Column(
                      children: [
                        // 2. Hero Status Card (In Progress - On the way to customer)
                        const OrderHeroStatusCard(),

                        const SizedBox(height: 12),

                        // 3. Order Information Card
                        const OrderInfoCard(),

                        const SizedBox(height: 12),

                        // 4. Pickup Information Card
                        PickupInformationCard(
                          onCallSeller: () {
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
                          onViewOnMap: () {
                            context.pushNamed(AppRoutes.activeOrders);
                          },
                        ),

                        const SizedBox(height: 12),

                        // 5. Customer Delivery Information Card
                        CustomerDeliveryInfoCard(
                          onCallCustomer: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Calling Priya Sharma (+91 98765 43210)...',
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
                          onViewOnMap: () {
                            context.pushNamed(AppRoutes.activeOrders);
                          },
                        ),

                        const SizedBox(height: 12),

                        // 6. Delivery Information Card
                        const DeliveryStatsInfoCard(),

                        const SizedBox(height: 16),

                        // 7. Bottom Navigate Button
                        NavigateToCustomerButton(
                          onNavigateTap: () {
                            context.pushNamed(AppRoutes.activeOrders);
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
class OrderDetailAppBar extends StatelessWidget {
  final String orderId;
  final VoidCallback onBackTap;

  const OrderDetailAppBar({
    super.key,
    required this.orderId,
    required this.onBackTap,
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

          // Title & Subtitle
          Column(
            children: [
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                orderId,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          // Spacer to balance back button
          const SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }
}

// =============================================================================
// 2. Hero Status Card
// =============================================================================
class OrderHeroStatusCard extends StatelessWidget {
  const OrderHeroStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.timerGreenBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.timerGreenBorder, width: 1.2),
      ),
      child: Row(
        children: [
          // Circular Delivery Scooter Icon
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.acceptGreen.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AppImages.deliveryBikeP,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.two_wheeler_rounded,
                color: AppColors.acceptGreen,
                size: 32,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Status & Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'In Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'On the way to customer',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGreyDark,
                    fontWeight: FontWeight.w500,
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
// 3. Order Information Card
// =============================================================================
class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({super.key});

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
          // Header
          Row(
            children: const [
              Icon(
                Icons.description_outlined,
                color: AppColors.primaryOrange,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Order Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildRow('Order Reference', '#SVN10245', isBold: true),
          const SizedBox(height: 8),
          _buildRow('Order Date & Time', '03 Nov 2026, 10:15 AM'),
          const SizedBox(height: 8),

          // Payment Status
          Row(
            children: [
              const Expanded(
                flex: 5,
                child: Text(
                  'Payment Status',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Text(
                ': ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                flex: 6,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.paidGreenBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Paid Online',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.acceptGreen,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 4. Pickup Information Card
// =============================================================================
class PickupInformationCard extends StatelessWidget {
  final VoidCallback onCallSeller;
  final VoidCallback onViewOnMap;

  const PickupInformationCard({
    super.key,
    required this.onCallSeller,
    required this.onViewOnMap,
  });

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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.storefront_rounded,
                    color: AppColors.primaryOrange,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Pickup Information',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),

              // Call Button
              GestureDetector(
                onTap: onCallSeller,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.acceptGreen,
                      width: 1.2,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 13,
                        color: AppColors.acceptGreen,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Call',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.acceptGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Seller Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                width: 90,
                child: Text(
                  'Seller Name',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                ':  ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  'ABC Store',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                width: 90,
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                ':  ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  '12, Anna Nagar Main Road,\nChennai - 600040',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textColor,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Mini Map Container
          OrderMiniMapPreview(
            markerColor: AppColors.primaryOrange,
            onViewTap: onViewOnMap,
          ),

          const SizedBox(height: 10),

          // Alert banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightPeachBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppColors.primaryOrange,
                  size: 15,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pickup Instructions: Please collect all items.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
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
// 5. Customer Delivery Information Card
// =============================================================================
class CustomerDeliveryInfoCard extends StatelessWidget {
  final VoidCallback onCallCustomer;
  final VoidCallback onViewOnMap;

  const CustomerDeliveryInfoCard({
    super.key,
    required this.onCallCustomer,
    required this.onViewOnMap,
  });

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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.person_pin_circle_rounded,
                    color: AppColors.acceptGreen,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Customer Delivery Information',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),

              // Call Button
              GestureDetector(
                onTap: onCallCustomer,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.acceptGreen,
                      width: 1.2,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 13,
                        color: AppColors.acceptGreen,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Call',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.acceptGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Customer Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                width: 90,
                child: Text(
                  'Customer Name',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                ':  ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  'Priya Sharma',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                width: 90,
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                ':  ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  '18, MG Road, Chennai - 600040',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textColor,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Mini Map Container
          OrderMiniMapPreview(
            markerColor: AppColors.acceptGreen,
            onViewTap: onViewOnMap,
          ),

          const SizedBox(height: 10),

          // Alert banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.paidGreenBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppColors.acceptGreen,
                  size: 15,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Delivery Instructions: Call before delivery.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
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

// Mini Map Preview with View on Map Button
class OrderMiniMapPreview extends StatelessWidget {
  final Color markerColor;
  final VoidCallback onViewTap;

  const OrderMiniMapPreview({
    super.key,
    required this.markerColor,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background subtle grid
            Positioned.fill(
              child: CustomPaint(
                painter: MiniMapGridPainter(),
              ),
            ),

            // Location Pin
            Positioned(
              left: 36,
              child: Icon(
                Icons.location_on,
                color: markerColor,
                size: 26,
              ),
            ),

            // View on Map > Button
            Positioned(
              right: 12,
              child: GestureDetector(
                onTap: onViewTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderGrey),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View on Map',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: AppColors.textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = AppColors.primaryOrange;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final roadPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 3;

    canvas.drawLine(Offset(0, 20), Offset(size.width, 24), roadPaint);
    canvas.drawLine(Offset(0, 48), Offset(size.width, 44), roadPaint);
    canvas.drawLine(Offset(size.width * 0.45, 0), Offset(size.width * 0.4, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// 6. Delivery Statistics Info Card
// =============================================================================
class DeliveryStatsInfoCard extends StatelessWidget {
  const DeliveryStatsInfoCard({super.key});

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
          // Header
          Row(
            children: const [
              Icon(
                Icons.route_rounded,
                color: AppColors.acceptGreen,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Delivery Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildStatRow('Distance', '4.5 km'),
          const SizedBox(height: 6),
          _buildStatRow('Estimated Time', '20 min'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          ':  ',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 7. Bottom Navigate Button
// =============================================================================
class NavigateToCustomerButton extends StatelessWidget {
  final VoidCallback onNavigateTap;

  const NavigateToCustomerButton({super.key, required this.onNavigateTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigateTap,
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
              Icons.near_me_rounded,
              color: AppColors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Navigate to Customer',
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

