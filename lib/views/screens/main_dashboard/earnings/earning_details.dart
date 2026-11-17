import 'package:flutter/material.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/pickup/pickup_details_screen.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';

class EarningDetails extends StatelessWidget {
  const EarningDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Earnings Details'),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: const [
          DeliveryInfoSummaryCard(),
          SizedBox(height: 15),
          PartnerEarningsBreakdownCard(),
          SizedBox(height: 15),
          PayoutInformationCard(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class DeliveryInfoSummaryCard extends StatelessWidget {
  const DeliveryInfoSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                "https://cdn-icons-png.flaticon.com/128/726/726455.png",
                height: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Delivery Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                width: 95,
                height: 78,
                decoration: BoxDecoration(
                  color: AppColors.surfaceGrey,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Image.asset(AppImages.deliveryBikeP, height: 68),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'SVN10245',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textColor,
                              ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.paidGreenBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.paidGreenBorder,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.acceptGreen,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Delivered',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.acceptGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: const [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '03 Nov 2026',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: const [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '07:15 PM',
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
        ],
      ),
    );
  }
}

class PartnerEarningsBreakdownCard extends StatelessWidget {
  const PartnerEarningsBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.acceptGreen.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withValues(alpha: .7),
                  AppColors.primaryOrange,
                  AppColors.primaryOrangeDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: .5),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/128/9715/9715374.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Partner Earnings',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹85.00',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DetailRow(label: 'Base Delivery Earnings', value: '₹70.00'),
                const SizedBox(height: 10),
                DetailRow(label: 'Additional Incentives', value: '₹10.00'),
                const SizedBox(height: 10),
                DetailRow(label: 'Other Bonuses', value: '₹5.00'),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderGrey, height: 1),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Partner Earnings',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      '₹85.00',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PayoutInformationCard extends StatelessWidget {
  const PayoutInformationCard({super.key});

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
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.lightPeachBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primaryOrange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Payout Information',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Payout Amount',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '₹85.00',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.processingBlueBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.processingBlueBorder),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: AppColors.processingBlueText,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Processing',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.processingBlueText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          DetailRow(label: 'Payout Reference No', value: 'PAY20261104-001'),
          const SizedBox(height: 10),
          DetailRow(label: 'Payout Date', value: '04 Nov 2026'),
          const SizedBox(height: 10),
          DetailRow(label: 'Payment Method', value: 'Bank Transfer'),
        ],
      ),
    );
  }
}
