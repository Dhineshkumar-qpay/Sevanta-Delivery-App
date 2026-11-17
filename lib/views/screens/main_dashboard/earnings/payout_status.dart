import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';

class PayoutStatus extends StatelessWidget {
  const PayoutStatus({super.key});

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
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goNamed(AppRoutes.mainDashboard);
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.borderGrey,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      const Text(
                        'Payout Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Total Earnings Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.earningsHeroGreenStart,
                                AppColors.earningsHeroGreenEnd,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.acceptGreen.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: AppColors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Total Earnings',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '₹12,450',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Payout Summary Section Title
                        const Text(
                          'Payout Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Pending Payout
                        _buildSummaryItem(
                          icon: Icons.access_time_rounded,
                          iconBgColor: AppColors.pendingOrangeBg,
                          iconColor: AppColors.pendingOrangeText,
                          title: 'Pending Payout',
                          amount: '₹1,200',
                          onTap: () {},
                        ),

                        const SizedBox(height: 10),

                        // Processing
                        _buildSummaryItem(
                          icon: Icons.sync_rounded,
                          iconBgColor: AppColors.processingBlueBg,
                          iconColor: AppColors.processingBlueText,
                          title: 'Processing',
                          amount: '₹2,000',
                          onTap: () {},
                        ),

                        const SizedBox(height: 10),

                        // Completed Payout
                        _buildSummaryItem(
                          icon: Icons.check_circle_rounded,
                          iconBgColor: AppColors.paidGreenBg,
                          iconColor: AppColors.paidGreenText,
                          title: 'Completed Payout',
                          amount: '₹9,250',
                          onTap: () {},
                        ),

                        const SizedBox(height: 22),

                        // Recent Payouts Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Payouts',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(AppRoutes.earningHistory);
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.acceptGreen,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 16,
                                    color: AppColors.acceptGreen,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _buildRecentPayoutCard(
                          date: 'Paid on 28 Oct 2026',
                          amount: '₹4,500',
                          account: 'UPI • ****1234',
                        ),

                        const SizedBox(height: 10),

                        _buildRecentPayoutCard(
                          date: 'Paid on 20 Oct 2026',
                          amount: '₹4,750',
                          account: 'UPI • ****1234',
                        ),

                        const SizedBox(height: 16),

                        // Info Notice Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.timerGreenBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.timerGreenBorder,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.info_rounded,
                                color: AppColors.acceptGreen,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Next payout will be processed on 10 Nov 2026',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.timerGreen,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String amount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPayoutCard({
    required String date,
    required String amount,
    required String account,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.paidGreenBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.acceptGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  account,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
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
