import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 190,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: const BoxDecoration(color: AppColors.backgroundColor),
            margin: EdgeInsets.only(top: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryOrange.withValues(alpha: 0.15),
                          AppColors.primaryOrange.withValues(alpha: 0.05),
                          AppColors.primaryOrange.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryOrange,
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.backgroundColor,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Good Morning!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryOrange,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textColor,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Hello, ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Rohit Sharma',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notification
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.newDeliveryRequest);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              child: Image.network(
                                'https://cdn-icons-png.flaticon.com/128/4991/4991422.png',
                                height: 28,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.notifications_outlined,
                                    size: 28,
                                    color: AppColors.textColor,
                                  );
                                },
                              ),
                            ),

                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  '2',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 12,
                  child: _BuildOnlineStatusCard(
                    isOnline: isOnline,
                    onTap: () {
                      setState(() {
                        isOnline = !isOnline;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BuildSectionTitle(
                icon: 'https://cdn-icons-png.flaticon.com/128/2272/2272120.png',
                title: "Today's Performance",
                actionText: 'View All >',
                onActionTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsGeometry.fromLTRB(15, 15, 15, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _PerformanceCard(
                        icon:
                            'https://cdn-icons-png.flaticon.com/128/9561/9561688.png',
                        title: "Today's Completed\nDeliveries",
                        count: '₹20',
                        color: Colors.deepOrange.shade50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _PerformanceCard(
                        icon:
                            'https://cdn-icons-png.flaticon.com/128/1041/1041888.png',
                        title: "Today's Earnings",
                        count: '₹299',
                        color: Colors.orange.shade100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: _TotalEarningsCard()),

            SliverToBoxAdapter(
              child: BuildSectionTitle(
                icon: 'https://cdn-icons-png.flaticon.com/128/1946/1946770.png',
                title: 'Active Delivery',
                actionText: 'View Details >',
                onActionTap: () {
                  context.pushNamed(AppRoutes.deliveryDetails);
                },
              ),
            ),
            SliverToBoxAdapter(child: _BuildActiveDeliveryCard()),
          ],
        ),
      ),
    );
  }
}

class BuildSectionTitle extends StatelessWidget {
  const BuildSectionTitle({
    required this.icon,
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  final String icon;
  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Image.network(icon, height: 24, width: 24),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textColor,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB0B9C7)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BuildOnlineStatusCard extends StatelessWidget {
  const _BuildOnlineStatusCard({required this.isOnline, required this.onTap});

  final bool isOnline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white, width: 1.5),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -5,
                left: -5,
                child: Icon(
                  Icons.flare_rounded,
                  size: 14,
                  color: AppColors.primaryOrange.withValues(alpha: 0.5),
                ),
              ),

              Image.network(
                isOnline
                    ? 'https://cdn-icons-png.flaticon.com/128/16786/16786007.png'
                    : "https://cdn-icons-png.flaticon.com/128/4752/4752467.png",
                height: 40,
              ),
            ],
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                    children: [
                      const TextSpan(text: 'You are '),
                      TextSpan(
                        text: isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: isOnline
                              ? AppColors.successText
                              : AppColors.errorText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOnline
                      ? 'Ready to receive delivery requests'
                      : 'Go online to receive delivery requests',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              width: 58,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isOnline
                    ? AppColors.primaryOrange
                    : Colors.grey.shade300,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                alignment: isOnline
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  });

  final String icon, title, count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.network(icon, height: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  count,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textColor,
                    height: 1,
                    letterSpacing: 1,
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

class _TotalEarningsCard extends StatelessWidget {
  const _TotalEarningsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 25),
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.white, width: 1.5),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withValues(alpha: .7),
            AppColors.primaryOrange,
            AppColors.primaryOrangeDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrangeDark.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/128/14034/14034774.png',
                      height: 30,
                      color: AppColors.white,
                    ),
                    Text(
                      'Total Earnings',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  '₹12,450',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 70,
            width: 2,
            color: AppColors.white.withValues(alpha: .2),
          ),

          SizedBox(
            width: 130,
            height: 72,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Center(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/128/126/126425.png',
                    height: 80,
                    width: 100,
                    color: Colors.white10,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/128/8759/8759584.png',
                    height: 50,
                    fit: BoxFit.contain,
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

class _BuildActiveDeliveryCard extends StatelessWidget {
  const _BuildActiveDeliveryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEF1F6), width: 1.2),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(text: 'Order ID : '),
                    TextSpan(
                      text: '#ORD10245',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
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
                  color: const Color(0xFFE8F7ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.moped_rounded,
                      color: Color(0xFF249D4A),
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'On the Way',
                      style: TextStyle(
                        color: Color(0xFF249D4A),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primaryOrange,
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Pickup:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF757E95),
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Fruit Shop',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 6.5,
                        top: 2,
                        bottom: 2,
                      ),
                      child: CustomPaint(
                        size: const Size(2, 20),
                        painter: _DottedLinePainter(),
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.radio_button_checked,
                            color: AppColors.successText,
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Drop:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF757E95),
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'MG Road, Chennai',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                flex: 9,
                child: Container(
                  height: 98,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.borderGrey, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(AppImages.delivery, fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            title: 'View Details >',
            onPressed: () {
              context.pushNamed(AppRoutes.deliveryDetails);
            },
          ),
        ],
      ),
    );
  }
}
