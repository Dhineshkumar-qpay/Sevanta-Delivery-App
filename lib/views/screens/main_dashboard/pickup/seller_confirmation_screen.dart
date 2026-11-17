import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';

class SellerConfirmationScreen extends StatelessWidget {
  const SellerConfirmationScreen({super.key});

  void _onCheckStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/128/6784/6784655.png",
              height: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'Handover Confirmed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ABC Store has confirmed handing over the package. You can now start heading to the customer location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textGreyDark,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: "Start Delivery",
              onPressed: () {
                Navigator.of(ctx).pop();
                context.pushNamed(AppRoutes.deliveryDetails);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Seller Confirmation'),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          // Parcel Status & Order Card
          const ParcelStatusHeaderCard(),

          const SizedBox(height: 16),

          // Handover Hero Illustration
          const HandoverHeroIllustration(),

          const SizedBox(height: 14),

          // Title & Subtitle
          Center(
            child: const Text(
              'Confirm Order Handover',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textColor,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Please ask the seller to confirm that the order has been handed over to you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textGrey,
                height: 1.35,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Handover Status Details Card
          const HandoverStatusCard(),

          const SizedBox(height: 20),

          CustomButton(
            title: "Check Confirmation Status",
            onPressed: () => _onCheckStatus(context),
          ),
        ],
      ),
    );
  }
}

class ParcelStatusHeaderCard extends StatelessWidget {
  const ParcelStatusHeaderCard({super.key});

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
        children: [
          Row(
            children: [
              // 3D Parcel Box Illustration with green checkmark
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.lightPeachBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/128/685/685388.png',
                      height: 42,
                      width: 42,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.inventory_2_rounded,
                        color: AppColors.primaryOrange,
                        size: 34,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.acceptGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Order Reference',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '#SVN10245',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'Seller: ',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                          TextSpan(
                            text: 'ABC Store',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 13,
                          color: AppColors.primaryOrange,
                        ),
                        SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '12, Anna Nagar Main Road, Chennai - 600040',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textGrey,
                            ),
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

          // Order Status Banner: Ready for Pickup
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.timerGreenBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 16,
                  color: AppColors.acceptGreen,
                ),
                SizedBox(width: 6),
                Text(
                  'Order Status: Ready for Pickup',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.acceptGreen,
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

class HandoverHeroIllustration extends StatelessWidget {
  const HandoverHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 125,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Storefront
              Image.network(
                'https://cdn-icons-png.flaticon.com/128/869/869636.png',
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.storefront_rounded,
                  size: 70,
                  color: AppColors.primaryOrange,
                ),
              ),

              const SizedBox(width: 20),

              // Delivery guy with parcel
              Image.network(
                'https://cdn-icons-png.flaticon.com/128/3063/3063823.png',
                height: 85,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.delivery_dining_rounded,
                  size: 70,
                  color: AppColors.acceptGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Handover Status Card
// ---------------------------------------------------------------------------
class HandoverStatusCard extends StatelessWidget {
  const HandoverStatusCard({super.key});

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
        children: [
          // Seller Name
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Seller Name',
            valueWidget: const Text(
              'ABC Store',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textColor,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.surfaceGrey, height: 1),
          ),

          // Confirmation Status
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Confirmation Status',
            valueWidget: const Text(
              'Waiting for Seller Confirmation',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.warningOrangeText,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.surfaceGrey, height: 1),
          ),

          // Confirmation Date & Time
          _buildInfoRow(
            icon: Icons.calendar_month_outlined,
            label: 'Confirmation Date & Time',
            valueWidget: const Text(
              '-',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              valueWidget,
            ],
          ),
        ),
      ],
    );
  }
}
