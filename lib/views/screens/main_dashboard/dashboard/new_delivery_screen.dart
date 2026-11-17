import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';

class NewDeliveryScreen extends StatefulWidget {
  const NewDeliveryScreen({super.key});

  @override
  State<NewDeliveryScreen> createState() => _NewDeliveryScreenState();
}

typedef NewDeliveryRequest = NewDeliveryScreen;

class _NewDeliveryScreenState extends State<NewDeliveryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'New Delivery Request'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.white, width: 1.5),
                ),
                child: Row(
                  children: [
                    // Earnings illustration
                    Container(
                      height: 82,
                      width: 82,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/1041/1041888.png",
                        height: 55,
                        width: 55,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Vertical divider
                    Container(
                      height: 78,
                      width: 1,
                      color: AppColors.lightOrangeBorder,
                    ),

                    const SizedBox(width: 14),

                    // Earnings information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and icon
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 15,
                                color: AppColors.textColor,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Expected Earnings',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '₹85.00',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryOrange,
                                  height: 1.05,
                                ),
                          ),

                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 7,
                            runSpacing: 6,
                            children: [
                              _EarningInfoChip(
                                icon: Icons.location_on_rounded,
                                text: '4.5 km',
                              ),
                              _EarningInfoChip(
                                icon: Icons.access_time_rounded,
                                text: '20 min',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const SizedBox(height: 12),

              // Pickup Location Card
              PickupLocationCard(),

              const SizedBox(height: 12),

              // Delivery Location Card
              DeliveryLocationCard(),

              const SizedBox(height: 12),

              // Delivery Information Breakdown Card
              DeliveryInformationCard(),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Reject Request Button
              Expanded(
                child: CustomOutlineButton(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.mainDashboard);
                    }
                  },
                  color: AppColors.rejectRed,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_rounded,
                        color: AppColors.rejectRed,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.rejectRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  title: 'Accept',
                  onPressed: () {
                    context.pushNamed(AppRoutes.pickupDetails);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable information chip
class _EarningInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EarningInfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.lightOrangeBorder.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class PickupLocationCard extends StatelessWidget {
  const PickupLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icons.storefront_rounded,
                      color: AppColors.primaryOrange,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Pickup Location',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              // Contact Seller Pill Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Store Name & Address
          Text(
            'ABC Store',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.primaryOrange),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  '12, Anna Nagar Main Road, Chennai - 600040',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    height: 1.3,
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

class DeliveryLocationCard extends StatelessWidget {
  const DeliveryLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.darkTextColor.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.darkTextColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Delivery Location',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              // Contact Customer Pill Button
              GestureDetector(
                onTap: () {
                  // Call customer
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Customer Name & Address
          Text(
            'Arjun Kumar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '45, MG Road, Chennai - 600001',
            style: TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

class DeliveryInformationCard extends StatelessWidget {
  const DeliveryInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: AppColors.primaryOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Breakdown',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Distance, charges & earnings summary',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Distance highlight section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.lightOrangeBg,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.lightOrangeBorder),
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/128/1634/1634189.png",
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Delivery Distance',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '4.5 km',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Breakdown heading
          Row(
            children: [
              Text(
                'Earnings Details',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(width: 7),
              Expanded(
                child: Divider(color: AppColors.lightBorderGrey, thickness: 1),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // Delivery charge
          BuildPremiumBreakDownRow(
            icon: "https://cdn-icons-png.flaticon.com/128/8441/8441282.png",
            title: 'Delivery Charge',
            value: '₹40.00',
          ),

          const SizedBox(height: 13),

          // Additional incentive
          BuildPremiumBreakDownRow(
            icon: "https://cdn-icons-png.flaticon.com/128/10845/10845495.png",
            title: 'Additional Incentive',
            value: '₹0.00',
          ),

          const SizedBox(height: 15),

          // Total earnings highlight
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.successGreen, AppColors.successGreenText],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expected Partner Earnings',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Your estimated payout',
                        style: TextStyle(fontSize: 9.5, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹85.00',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
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

class BuildPremiumBreakDownRow extends StatelessWidget {
  const BuildPremiumBreakDownRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final String icon, title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F7),
            borderRadius: BorderRadius.circular(9),
          ),
          padding: EdgeInsets.all(5),
          child: Image.network(icon, height: 24),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
