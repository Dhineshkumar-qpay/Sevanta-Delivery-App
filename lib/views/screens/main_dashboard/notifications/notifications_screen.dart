import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;

  final List<NotificationFilterItem> _filters = const [
    NotificationFilterItem(title: 'All', count: '24'),
    NotificationFilterItem(title: 'Orders', count: '10'),
    NotificationFilterItem(title: 'Earnings', count: '6'),
    NotificationFilterItem(title: 'Account', count: '4'),
    NotificationFilterItem(title: 'General', count: '4'),
  ];

  late List<NotificationItemData> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      const NotificationItemData(
        id: '1',
        title: 'New Delivery Request',
        description: 'A new delivery request has been assigned to you.',
        time: '5 min ago',
        category: NotificationCategory.orders,
        isUnread: true,
        type: NotificationType.newDelivery,
      ),
      const NotificationItemData(
        id: '2',
        title: 'Order Accepted',
        description: 'Your delivery request has been accepted successfully.',
        time: '15 min ago',
        category: NotificationCategory.orders,
        isUnread: true,
        type: NotificationType.orderAccepted,
      ),
      const NotificationItemData(
        id: '3',
        title: 'Payment Completed',
        description:
            'Your delivery earnings have been credited to your account.',
        time: '1 hour ago',
        category: NotificationCategory.earnings,
        isUnread: false,
        type: NotificationType.paymentCompleted,
      ),
      const NotificationItemData(
        id: '4',
        title: 'Document Verified',
        description: 'Your submitted document has been verified successfully.',
        time: '2 hours ago',
        category: NotificationCategory.account,
        isUnread: false,
        type: NotificationType.documentVerified,
      ),
      const NotificationItemData(
        id: '5',
        title: 'New Announcement',
        description: 'Check out the latest updates from Sevanta.',
        time: '1 day ago',
        category: NotificationCategory.general,
        isUnread: false,
        type: NotificationType.announcement,
      ),
    ];
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const BodyTextColors(
          title: 'All notifications cleared',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.textColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((item) => item.copyWith(isUnread: false))
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const BodyTextColors(
          title: 'All notifications marked as read',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.acceptGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  List<NotificationItemData> get _filteredNotifications {
    if (_selectedFilterIndex == 0) return _notifications;
    final selectedCategory = switch (_selectedFilterIndex) {
      1 => NotificationCategory.orders,
      2 => NotificationCategory.earnings,
      3 => NotificationCategory.account,
      4 => NotificationCategory.general,
      _ => null,
    };
    if (selectedCategory == null) return _notifications;
    return _notifications
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredNotifications;

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
                _NotificationsAppBar(
                  onBackTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.mainDashboard);
                    }
                  },
                  onClearAllTap: _clearAllNotifications,
                  onMarkAllAsRead: _markAllAsRead,
                  onSettingsTap: () {
                    context.pushNamed(AppRoutes.profile);
                  },
                ),

                const SizedBox(height: 10),

                // 2. Filter Tabs
                _NotificationFilterTabsRow(
                  filters: _filters,
                  selectedIndex: _selectedFilterIndex,
                  onSelect: (index) {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                  },
                ),

                const SizedBox(height: 14),

                // 3. Notification List
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 52,
                                color: AppColors.textGrey.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 10),
                              const HeaderTextBlack(
                                title: 'No notifications found',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 4),
                              const BodyTextHint(
                                title: 'You will see your notifications here.',
                                fontSize: 12,
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          children: [
                            ...List.generate(
                              list.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: NotificationCard(
                                  item: list[index],
                                  onTap: () {
                                    context.pushNamed(
                                      AppRoutes.notificationDetails,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const CaughtUpBanner(),
                          ],
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

class _NotificationsAppBar extends StatelessWidget {
  const _NotificationsAppBar({
    required this.onBackTap,
    required this.onClearAllTap,
    required this.onMarkAllAsRead,
    required this.onSettingsTap,
  });

  final VoidCallback onBackTap;
  final VoidCallback onClearAllTap;
  final VoidCallback onMarkAllAsRead;
  final VoidCallback onSettingsTap;

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
            child: HeaderTextBlack(
              title: 'Notifications',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          // Clear All Button
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onClearAllTap,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: BodyTextColors(
                title: 'Clear All',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.acceptGreen,
              ),
            ),
          ),

          // 3-dots Menu
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textColor,
              size: 20,
            ),
            elevation: 8,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'mark_read') {
                onMarkAllAsRead();
              } else if (value == 'settings') {
                onSettingsTap();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: const [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 10),
                    HeaderTextBlack(
                      title: 'Mark All as Read',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: const [
                    Icon(
                      Icons.settings_outlined,
                      size: 18,
                      color: AppColors.textColor,
                    ),
                    SizedBox(width: 10),
                    HeaderTextBlack(
                      title: 'Notification Settings',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

class _NotificationFilterTabsRow extends StatelessWidget {
  const _NotificationFilterTabsRow({
    required this.filters,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<NotificationFilterItem> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final item = filters[index];

          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: const BoxConstraints(minWidth: 68),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.acceptGreen : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.acceptGreen
                      : AppColors.borderGrey,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.acceptGreen.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isSelected
                      ? BodyTextColors(
                          title: item.title,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        )
                      : HeaderTextBlack(
                          title: item.title,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                  const SizedBox(height: 2),
                  isSelected
                      ? BodyTextColors(
                          title: '(${item.count})',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        )
                      : BodyTextHint(
                          title: '(${item.count})',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final NotificationItemData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(item.type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
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
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: style.bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                style.icon,
                color: style.iconColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderTextBlack(
                    title: item.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 4),
                  BodyTextHint(
                    title: item.description,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      BodyTextHint(
                        title: item.time,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Trailing Unread Dot & Chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item.isUnread) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  const SizedBox(height: 18),
                ],
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.iconGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _NotificationTypeStyle _getCategoryStyle(NotificationType type) {
    return switch (type) {
      NotificationType.newDelivery => const _NotificationTypeStyle(
          bgColor: Color(0xFFFFEBD9),
          iconColor: AppColors.primaryOrange,
          icon: Icons.delivery_dining_rounded,
        ),
      NotificationType.orderAccepted => const _NotificationTypeStyle(
          bgColor: Color(0xFFE8F7EE),
          iconColor: AppColors.acceptGreen,
          icon: Icons.check_circle_rounded,
        ),
      NotificationType.paymentCompleted => const _NotificationTypeStyle(
          bgColor: Color(0xFFE8F1FC),
          iconColor: Color(0xFF1976D2),
          icon: Icons.account_balance_wallet_rounded,
        ),
      NotificationType.documentVerified => const _NotificationTypeStyle(
          bgColor: Color(0xFFF3E8FC),
          iconColor: Color(0xFF8E24AA),
          icon: Icons.article_rounded,
        ),
      NotificationType.announcement => const _NotificationTypeStyle(
          bgColor: Color(0xFFEAF7EE),
          iconColor: Color(0xFF2E7D32),
          icon: Icons.campaign_rounded,
        ),
    };
  }
}

class CaughtUpBanner extends StatelessWidget {
  const CaughtUpBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFC8E6C9),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.acceptGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              size: 22,
              color: AppColors.acceptGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HeaderTextBlack(
                  title: "You're all caught up!",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 2),
                BodyTextHint(
                  title: 'No more notifications at the moment.',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTypeStyle {
  final Color bgColor;
  final Color iconColor;
  final IconData icon;

  const _NotificationTypeStyle({
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  });
}

class NotificationFilterItem {
  final String title;
  final String count;

  const NotificationFilterItem({
    required this.title,
    required this.count,
  });
}

enum NotificationCategory { orders, earnings, account, general }

enum NotificationType {
  newDelivery,
  orderAccepted,
  paymentCompleted,
  documentVerified,
  announcement,
}

class NotificationItemData {
  final String id;
  final String title;
  final String description;
  final String time;
  final NotificationCategory category;
  final bool isUnread;
  final NotificationType type;

  const NotificationItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.isUnread,
    required this.type,
  });

  NotificationItemData copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    NotificationCategory? category,
    bool? isUnread,
    NotificationType? type,
  }) {
    return NotificationItemData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      category: category ?? this.category,
      isUnread: isUnread ?? this.isUnread,
      type: type ?? this.type,
    );
  }
}
