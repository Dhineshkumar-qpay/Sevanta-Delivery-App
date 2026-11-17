import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_time_picker.dart';

class EarningHistory extends StatefulWidget {
  const EarningHistory({super.key});

  @override
  State<EarningHistory> createState() => _EarningHistoryState();
}

class _EarningHistoryState extends State<EarningHistory> {
  int _selectedFilterIndex = 2;
  final List<String> _filters = [
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
  ];

  final List<EarningRecordItem> _earningsList = const [
    EarningRecordItem(
      orderId: 'SVN10250',
      dateTime: '04 Nov 2026 • 06:45 PM',
      breakdown: 'Base: ₹70 + Incentive: ₹15',
      amount: '₹85.00',
      status: EarningStatus.paid,
    ),
    EarningRecordItem(
      orderId: 'SVN10249',
      dateTime: '04 Nov 2026 • 05:20 PM',
      breakdown: 'Base: ₹60 + Incentive: ₹10',
      amount: '₹70.00',
      status: EarningStatus.processing,
    ),
    EarningRecordItem(
      orderId: 'SVN10248',
      dateTime: '04 Nov 2026 • 04:10 PM',
      breakdown: 'Base: ₹65 + Incentive: ₹5',
      amount: '₹70.00',
      status: EarningStatus.pending,
    ),
    EarningRecordItem(
      orderId: 'SVN10247',
      dateTime: '03 Nov 2026 • 08:25 PM',
      breakdown: 'Base: ₹75 + Incentive: ₹10',
      amount: '₹85.00',
      status: EarningStatus.paid,
    ),
    EarningRecordItem(
      orderId: 'SVN10246',
      dateTime: '03 Nov 2026 • 07:15 PM',
      breakdown: 'Base: ₹70 + Incentive: ₹10',
      amount: '₹80.00',
      status: EarningStatus.paid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "Earnings History",
        actions: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.filter_list_outlined,
              color: AppColors.primaryOrange,
              size: 24,
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const EarningSummaryMetricsCard(
              totalEarnings: '₹48,250',
              totalPaid: '₹42,800',
              pending: '₹5,450',
            ),

            const SizedBox(height: 14),

            DateFilterPillsRow(
              filters: _filters,
              selectedIndex: _selectedFilterIndex,
              onSelect: (index) {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              onCalendarTap: () {
                CustomDatePicker.showPickDate(context);
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _earningsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.earningDetails);
                    },
                    child: EarningHistoryCard(item: _earningsList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum EarningStatus { paid, processing, pending }

class EarningRecordItem {
  final String orderId;
  final String dateTime;
  final String breakdown;
  final String amount;
  final EarningStatus status;

  const EarningRecordItem({
    required this.orderId,
    required this.dateTime,
    required this.breakdown,
    required this.amount,
    required this.status,
  });
}

class EarningSummaryMetricsCard extends StatelessWidget {
  final String totalEarnings;
  final String totalPaid;
  final String pending;

  const EarningSummaryMetricsCard({
    super.key,
    required this.totalEarnings,
    required this.totalPaid,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade100, Colors.orange.shade50],
          begin: AlignmentGeometry.topRight,
          end: AlignmentGeometry.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.lightOrangeBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: MetricColumn(
              icon: "https://cdn-icons-png.flaticon.com/128/8759/8759584.png",
              label: 'Total Earnings',
              amount: totalEarnings,
            ),
          ),

          Container(width: 1, height: 42, color: AppColors.lightOrangeBorder),

          Expanded(
            child: MetricColumn(
              icon: "https://cdn-icons-png.flaticon.com/128/190/190411.png",
              label: 'Total Paid',
              amount: totalPaid,
            ),
          ),

          Container(width: 1, height: 42, color: AppColors.lightOrangeBorder),

          Expanded(
            child: MetricColumn(
              icon: "https://cdn-icons-png.flaticon.com/128/12196/12196745.png",
              label: 'Pending',
              amount: pending,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricColumn extends StatelessWidget {
  final String icon;
  final String label;
  final String amount;

  const MetricColumn({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(icon, height: 24),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textColor,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class DateFilterPillsRow extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCalendarTap;

  const DateFilterPillsRow({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelect,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(filters.length, (index) {
            final isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onSelect(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryOrange
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.borderGrey,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.textColor,
                    ),
                  ),
                ),
              ),
            );
          }),

          GestureDetector(
            onTap: onCalendarTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderGrey, width: 1.2),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: AppColors.textColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EarningHistoryCard extends StatelessWidget {
  final EarningRecordItem item;

  const EarningHistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDER REFERENCE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textGrey.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Order ID : ${item.orderId}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.amount,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.acceptGreen,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Earning Amount',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            color: AppColors.borderGrey.withValues(alpha: 0.7),
            height: 1,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 15,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.dateTime,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textGreyDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildStatusPill(item.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 16,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.breakdown,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: AppColors.textGreyDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Status Badge
  Widget _buildStatusPill(EarningStatus status) {
    Color bg;
    Color text;
    Color border;
    IconData icon;
    String label;

    switch (status) {
      case EarningStatus.paid:
        bg = AppColors.paidGreenBg;
        text = AppColors.paidGreenText;
        border = AppColors.paidGreenBorder;
        icon = Icons.check_circle_rounded;
        label = 'Paid';
        break;

      case EarningStatus.processing:
        bg = AppColors.processingBlueBg;
        text = AppColors.processingBlueText;
        border = AppColors.processingBlueBorder;
        icon = Icons.autorenew_rounded;
        label = 'Processing';
        break;

      case EarningStatus.pending:
        bg = AppColors.pendingOrangeBg;
        text = AppColors.pendingOrangeText;
        border = AppColors.pendingOrangeBorder;
        icon = Icons.schedule_rounded;
        label = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
