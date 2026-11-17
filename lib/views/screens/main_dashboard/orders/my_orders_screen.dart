import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/dashboard/dashboard.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_text_field.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = const [
    'All',
    'New',
    'Accepted',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

  final List<OrderItemData> _orders = const [
    OrderItemData(
      orderId: 'SVN10245',
      storeName: 'ABC Store',
      storeAddress: 'Anna Nagar, Chennai',
      customerName: 'Priya Sharma',
      customerAddress: 'MG Road, Chennai',
      dateTime: '03 Nov 2026 • 10:15 AM',
      distance: '4.5 km',
      earnings: '₹85.00',
      status: OrderStatusType.inProgress,
    ),
    OrderItemData(
      orderId: 'SVN10244',
      storeName: 'Fresh Mart',
      storeAddress: 'T. Nagar, Chennai',
      customerName: 'Rahul Kumar',
      customerAddress: 'Mount Road, Chennai',
      dateTime: '03 Nov 2026 • 09:50 AM',
      distance: '6.2 km',
      earnings: '₹120.00',
      status: OrderStatusType.accepted,
    ),
    OrderItemData(
      orderId: 'SVN10243',
      storeName: 'Mega Store',
      storeAddress: 'Velachery, Chennai',
      customerName: 'Sneha Reddy',
      customerAddress: 'Adyar, Chennai',
      dateTime: '03 Nov 2026 • 09:20 AM',
      distance: '7.1 km',
      earnings: '₹95.00',
      status: OrderStatusType.newItem,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "My Orders", isLeading: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomSearchField(controller: TextEditingController()),
          ),
          SizedBox(height: 20),
          OrderFilterChipsRow(
            filters: _filters,
            selectedIndex: _selectedFilterIndex,
            onSelect: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
          ),

          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                children: [
                  ...List.generate(
                    _orders.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OrderSummaryCard(
                        order: _orders[index],
                        onViewDetailsTap: () {
                          context.pushNamed(AppRoutes.newDeliveryRequest);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const OrderLoadingFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum OrderStatusType { newItem, accepted, inProgress, completed, cancelled }

class OrderItemData {
  final String orderId;
  final String storeName;
  final String storeAddress;
  final String customerName;
  final String customerAddress;
  final String dateTime;
  final String distance;
  final String earnings;
  final OrderStatusType status;

  const OrderItemData({
    required this.orderId,
    required this.storeName,
    required this.storeAddress,
    required this.customerName,
    required this.customerAddress,
    required this.dateTime,
    required this.distance,
    required this.earnings,
    required this.status,
  });
}

class OrderFilterChipsRow extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const OrderFilterChipsRow({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(filters.length, (index) {
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
                  color: isSelected ? AppColors.primaryOrange : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryOrangeDark
                        : AppColors.borderGrey,
                    width: 1.2,
                  ),
                ),
                child: BodyTextColors(
                  title: filters[index],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.textColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  final OrderItemData order;
  final VoidCallback onViewDetailsTap;

  const OrderSummaryCard({
    super.key,
    required this.order,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: AppTextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                  ).textStyle,
                  children: [
                    TextSpan(text: 'Order ID : '),
                    TextSpan(
                      text: 'ORD10245',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              OrderStatusBadge(status: order.status),
            ],
          ),

          const SizedBox(height: 7),

          Align(
            alignment: Alignment.centerLeft,
            child: BodyTextHint(
              title: order.dateTime,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/128/869/869636.png',
                height: 60,
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    color: AppColors.primaryOrange,
                    size: 15,
                  ),
                  CustomPaint(
                    size: const Size(2, 45),
                    painter: DottedLinePainter(),
                  ),
                  Icon(
                    Icons.radio_button_checked,
                    color: AppColors.successText,
                    size: 15,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LocationItem(
                      title: 'PICKUP LOCATION',
                      name: order.storeName,
                      address: order.storeAddress,
                    ),
                    const SizedBox(height: 14),
                    _LocationItem(
                      title: 'DELIVERY LOCATION',
                      name: order.customerName,
                      address: order.customerAddress,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoItem(
                          icon:
                              "https://cdn-icons-png.flaticon.com/128/1634/1634189.png",
                          title: 'Distance',
                          value: order.distance,
                        ),
                      ),
                      Container(
                        height: 27,
                        width: 1,
                        color: AppColors.borderGrey,
                      ),
                      Expanded(
                        child: _InfoItem(
                          icon:
                              "https://cdn-icons-png.flaticon.com/128/1041/1041888.png",
                          title: 'Earnings',
                          value: order.earnings,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomOutlineButton(
                  onTap: onViewDetailsTap,
                  color: AppColors.primaryOrange,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeaderTextPrimary(
                        title: 'ViewDetails',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.primaryOrange,
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

class _LocationItem extends StatelessWidget {
  final String title;
  final String name;
  final String address;

  const _LocationItem({
    required this.title,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyTextHint(title: title, fontSize: 9, fontWeight: FontWeight.w500),
        const SizedBox(height: 3),
        HeaderTextBlack(title: name, fontSize: 11, fontWeight: FontWeight.w600),
        const SizedBox(height: 2),
        BodyTextColors(
          title: address,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.primaryOrange,
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(icon, height: 15),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyTextHint(
              title: title,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 5),
            HeaderTextBlack(
              title: value,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ],
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  final OrderStatusType status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case OrderStatusType.inProgress:
        bg = AppColors.paidGreenBg;
        text = AppColors.paidGreenText;
        label = 'In Progress';
        break;
      case OrderStatusType.accepted:
        bg = AppColors.paidGreenBg;
        text = AppColors.paidGreenText;
        label = 'Accepted';
        break;
      case OrderStatusType.newItem:
        bg = AppColors.waitingOrangeBg;
        text = AppColors.warningOrangeText;
        label = 'New';
        break;
      case OrderStatusType.completed:
        bg = AppColors.paidGreenBg;
        text = AppColors.paidGreenText;
        label = 'Completed';
        break;
      case OrderStatusType.cancelled:
        bg = AppColors.placeholderGrey;
        text = AppColors.rejectRed;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }
}

class OrderLoadingFooter extends StatelessWidget {
  const OrderLoadingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.sync_rounded, size: 16, color: AppColors.acceptGreen),
          SizedBox(width: 6),
          BodyTextColors(
            title: 'Loading more orders...',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.acceptGreen,
          ),
        ],
      ),
    );
  }
}
