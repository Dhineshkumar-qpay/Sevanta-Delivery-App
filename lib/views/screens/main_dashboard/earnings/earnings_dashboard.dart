import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/dashboard/dashboard.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';

class EarningsDashboard extends StatefulWidget {
  const EarningsDashboard({super.key});

  @override
  State<EarningsDashboard> createState() => _EarningsDashboardState();
}

class _EarningsDashboardState extends State<EarningsDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "My Earnings", isLeading: false),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoutes.earningHistory);
            },
            child: const TotalEarningsHeroCard(),
          ),

          const SizedBox(height: 20),

          BuildSectionTitle(
            title: 'Earnings Overview',
            icon: 'https://cdn-icons-png.flaticon.com/128/2272/2272120.png',
            actionText: '',
            onActionTap: () {},
          ),

          const SizedBox(height: 10),

          // 3 Metric Cards: Today, This Week, This Month
          const Row(
            children: [
              Expanded(
                child: OverviewMetricCard(
                  title: "Today's\nEarnings",
                  amount: '₹850',
                  icon:
                      "https://cdn-icons-png.flaticon.com/128/3652/3652191.png",
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: OverviewMetricCard(
                  title: "This Week's\nEarnings",
                  amount: '₹5,620',
                  icon:
                      "https://cdn-icons-png.flaticon.com/128/6706/6706193.png",
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: OverviewMetricCard(
                  title: "This Month's\nEarnings",
                  amount: '₹12,450',
                  icon: "https://cdn-icons-png.flaticon.com/128/668/668278.png",
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          BuildSectionTitle(
            title: 'Delivery Statistics',
            icon: 'https://cdn-icons-png.flaticon.com/128/2272/2272120.png',
            actionText: '',
            onActionTap: () {},
          ),

          const SizedBox(height: 10),

          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 110,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              DeliveryStatBadge(
                value: '120',
                label: 'Total Deliveries',
                icon: "https://cdn-icons-png.flaticon.com/128/726/726455.png",
              ),
              DeliveryStatBadge(
                value: '₹9,850',
                label: 'Delivery Earnings',
                icon:
                    "https://cdn-icons-png.flaticon.com/128/10536/10536043.png",
              ),
              DeliveryStatBadge(
                value: '₹600',
                label: 'Incentives',
                icon: "https://cdn-icons-png.flaticon.com/128/8814/8814256.png",
              ),
              DeliveryStatBadge(
                value: '₹2,650',
                label: 'Pending Payouts',
                icon:
                    "https://cdn-icons-png.flaticon.com/128/12196/12196745.png",
              ),
            ],
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class TotalEarningsHeroCard extends StatelessWidget {
  const TotalEarningsHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
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
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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

                const SizedBox(width: 20),

                // Total Earnings Amount
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Earnings',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '₹12,450',
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

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.lightOrangeBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Paid Amount',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.paidGreenBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: AppColors.acceptGreen,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '₹9,800',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textColor,
                                  letterSpacing: 1,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Divider line
                Container(width: 1, height: 36, color: AppColors.borderGrey),

                // Pending Payout
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pending Payout',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColors.pendingOrangeBg,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '₹2,650',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textColor,
                                    letterSpacing: 1,
                                  ),
                            ),
                          ],
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

class OverviewMetricCard extends StatelessWidget {
  final String title;
  final String amount;
  final String icon;

  const OverviewMetricCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Image.network(icon, height: 24),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryStatBadge extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const DeliveryStatBadge({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(icon, height: 24),
          const SizedBox(height: 10),
          // Value
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
