import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_snackbar.dart';

class PickupDetailsScreen extends StatelessWidget {
  const PickupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "Pickup Details"),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            StoreInfoCard(
              onCallSeller: () {
                CustomSnackBar.show(
                  context: context,
                  message: 'Calling ABC Store (+91 98765 43210)...',
                );
              },
              onNavigate: () {
                context.pushNamed(AppRoutes.deliveryDetails);
              },
            ),

            const SizedBox(height: 12),

            const PickupOrderInfoCard(),

            const SizedBox(height: 12),

            const PickupStatusStepperCard(),

            const SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: CustomButton(
            title: 'Confirm Pickup',
            onPressed: () {
              context.pushNamed(AppRoutes.verifyPickup);
            },
          ),
        ),
      ),
    );
  }
}

class StoreInfoCard extends StatelessWidget {
  final VoidCallback onCallSeller;
  final VoidCallback onNavigate;

  const StoreInfoCard({
    super.key,
    required this.onCallSeller,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/128/869/869432.png',
                  height: 55,
                  width: 55,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABC Store',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.phone, size: 13, color: AppColors.textColor),
                        SizedBox(width: 5),
                        Text(
                          '+91 98765 43210',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 13,
                          color: AppColors.primaryOrange,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '12, Anna Nagar Main Road, Chennai - 600040',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textGrey,
                              height: 1.25,
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

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 14, color: AppColors.textColor),
                SizedBox(width: 4),
                Text(
                  '4.5 km to Pickup Location',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: CustomOutlineButton(
                  onTap: onCallSeller,
                  color: AppColors.acceptGreen,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: AppColors.acceptGreen,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Call Seller',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.acceptGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: onNavigate,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.near_me_rounded,
                        size: 16,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Navigate',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
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

class PickupOrderInfoCard extends StatelessWidget {
  const PickupOrderInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: AppColors.primaryOrange,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Order Information',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          DetailRow(
            label: 'Order Reference No.',
            value: 'SVN10245',
            isBold: true,
          ),
          const SizedBox(height: 8),
          DetailRow(label: 'Items', value: '3 Items'),
          const SizedBox(height: 8),
          DetailRow(label: 'Preparation Status', value: 'Ready'),
          const SizedBox(height: 8),
          PaymentStatusRow(),
          const SizedBox(height: 8),
          DetailRow(label: 'Special Instructions', value: 'Handle with care'),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isStatus;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successGreenBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.successGreenBadge,
              ),
            ),
          )
        else
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
      ],
    );
  }
}

class PaymentStatusRow extends StatelessWidget {
  final String status;

  const PaymentStatusRow({super.key, this.status = 'Paid Online'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 140,
          child: Text(
            'Payment Status',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.successGreenBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            status,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.successGreenBadge,
            ),
          ),
        ),
      ],
    );
  }
}

class PickupStatusStepperCard extends StatelessWidget {
  const PickupStatusStepperCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
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
            'Pickup Status',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textColor,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepItem(
                iconWidget: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.acceptGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
                label: 'Delivery\nAccepted',
                textColor: AppColors.acceptGreen,
              ),

              _buildConnectorLine(isActive: true),

              _buildStepItem(
                iconWidget: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrangeAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
                label: 'Reached\nSeller',
                textColor: AppColors.textColor,
              ),

              _buildConnectorLine(isActive: false),

              _buildStepItem(
                iconWidget: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGrey,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.textGrey,
                    size: 15,
                  ),
                ),
                label: 'Order\nCollected',
                textColor: AppColors.textGrey,
              ),

              _buildConnectorLine(isActive: false),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.timerGreenBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppColors.acceptGreen,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please collect the order from the seller and confirm the pickup to continue delivery.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textColor,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
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

  Widget _buildStepItem({
    required Widget iconWidget,
    required String label,
    required Color textColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textColor,
            height: 1.15,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorLine({required bool isActive}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 15, left: 4, right: 4),
        height: 2,
        color: isActive ? AppColors.acceptGreen : AppColors.borderGrey,
      ),
    );
  }
}
