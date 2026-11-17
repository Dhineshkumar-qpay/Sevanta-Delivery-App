import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Ambient soft green curve on top-left
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
                    AppColors.acceptGreen.withValues(alpha: 0.18),
                    AppColors.acceptGreen.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. App Bar
                _NotificationDetailsAppBar(
                  onBackTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.mainDashboard);
                    }
                  },
                ),

                // 2. Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        // 3D Bell Illustration with leaves and badge
                        const NotificationBellHero(),

                        const SizedBox(height: 20),

                        // Title
                        const HeaderTextBlack(
                          title: 'New Delivery Request',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Description
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: HeaderTextBlack(
                            title:
                                'A new delivery request has been assigned to you. '
                                'Please accept it within the given time.',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Info Card: Date & Order Reference
                        const _OrderMetaInfoCard(),

                        const SizedBox(height: 16),

                        // Order Details Card
                        const _NotificationOrderDetailsCard(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // 3. Bottom Action Buttons
                _NotificationBottomActions(
                  onViewOrderTap: () {
                    context.pushNamed(AppRoutes.newDeliveryRequest);
                  },
                  onContactSupportTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const BodyTextColors(
                          title: 'Connecting to Sevanta Partner Support...',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        backgroundColor: AppColors.acceptGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(milliseconds: 1500),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationDetailsAppBar extends StatelessWidget {
  const _NotificationDetailsAppBar({required this.onBackTap});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onBackTap,
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Title
          const Expanded(
            child: Center(
              child: HeaderTextBlack(
                title: 'Notification Details',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Spacer to keep title centered
          const SizedBox(width: 38),
        ],
      ),
    );
  }
}

class NotificationBellHero extends StatelessWidget {
  const NotificationBellHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient soft halo and foliage aura
          Container(
            width: 200,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFD8F3E5).withValues(alpha: 0.7),
                  const Color(0xFFEAF7EE).withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Decorative light green leaf foliage
          Positioned(
            left: 50,
            bottom: 30,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 50,
                height: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFFA5D6A7).withValues(alpha: 0.6),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 50,
            bottom: 30,
            child: Transform.rotate(
              angle: 0.4,
              child: Container(
                width: 50,
                height: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFFA5D6A7).withValues(alpha: 0.6),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),

          // Paper Airplane floating on upper-right
          Positioned(
            right: 65,
            top: 25,
            child: Transform.rotate(
              angle: 0.1,
              child: const Icon(
                Icons.send_rounded,
                color: Color(0xFF66BB6A),
                size: 26,
              ),
            ),
          ),

          // 3D Green Bell Body with clapper and highlights
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Bell Body
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF66BB6A),
                          Color(0xFF388E3C),
                          Color(0xFF1B5E20),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Bell handle on top
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 20,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF81C784),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        // Inner gloss reflection
                        Positioned(
                          left: 14,
                          top: 24,
                          child: Container(
                            width: 14,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Red Badge with "1" on top right
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF15B2A),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF15B2A).withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const BodyTextColors(
                        title: '1',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // Clapper / Tongue of Bell
              Transform.translate(
                offset: const Offset(0, -6),
                child: Container(
                  width: 24,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderMetaInfoCard extends StatelessWidget {
  const _OrderMetaInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC8E6C9),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Row 1: Date & Time
          Row(
            children: const [
              Icon(
                Icons.calendar_month_rounded,
                color: AppColors.acceptGreen,
                size: 22,
              ),
              SizedBox(width: 12),
              HeaderTextBlack(
                title: 'Nov 04, 2026  •  09:45 AM',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 2: Order Reference
          Row(
            children: [
              const Icon(
                Icons.local_offer_rounded,
                color: AppColors.acceptGreen,
                size: 20,
              ),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Order Reference: ',
                      style: AppTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor,
                      ).textStyle,
                    ),
                    TextSpan(
                      text: '#SVN10245',
                      style: AppTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ).textStyle,
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
}

class _NotificationOrderDetailsCard extends StatelessWidget {
  const _NotificationOrderDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderGrey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: const [
              Icon(
                Icons.info_rounded,
                color: AppColors.acceptGreen,
                size: 22,
              ),
              SizedBox(width: 8),
              HeaderTextBlack(
                title: 'Order Details',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Detail Rows
          const _DetailRow(
            label: 'Seller Name',
            value: 'ABC Store',
          ),
          const SizedBox(height: 10),

          const _DetailRow(
            label: 'Pickup Address',
            value: '12, Anna Nagar Main Road,\nChennai - 600040',
          ),
          const SizedBox(height: 10),

          const _DetailRow(
            label: 'Customer Name',
            value: 'Priya Sharma',
          ),
          const SizedBox(height: 10),

          const _DetailRow(
            label: 'Delivery Address',
            value: '18, MG Road,\nChennai - 600001',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: HeaderTextBlack(
            title: label,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          width: 16,
          child: HeaderTextBlack(
            title: ':',
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: HeaderTextBlack(
            title: value,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _NotificationBottomActions extends StatelessWidget {
  const _NotificationBottomActions({
    required this.onViewOrderTap,
    required this.onContactSupportTap,
  });

  final VoidCallback onViewOrderTap;
  final VoidCallback onContactSupportTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary "View Order" Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onViewOrderTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.acceptGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.map_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  BodyTextColors(
                    title: 'View Order',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Secondary "Contact Support" Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onContactSupportTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppColors.acceptGreen,
                  width: 1.5,
                ),
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.call_rounded,
                    color: AppColors.acceptGreen,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  BodyTextColors(
                    title: 'Contact Support',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.acceptGreen,
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
