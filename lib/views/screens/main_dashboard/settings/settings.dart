import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

typedef ProfileScreen = Settings;

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'My Profile',
        isLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoutes.personalInformation);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGrey, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 18,
                    color: AppColors.primaryOrange,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            // Scrollable Profile Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(15, 4, 15, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Profile Card
                    HeroProfileCard(),

                    SizedBox(height: 14),

                    // Profile Details Section
                    ProfileDetailsCard(),

                    SizedBox(height: 14),

                    // Vehicle Information Section
                    VehicleInformationCard(),

                    SizedBox(height: 14),

                    // Service Area Section
                    ServiceAreaCard(),

                    SizedBox(height: 14),

                    // Document Status Section
                    DocumentStatusCard(),

                    SizedBox(height: 14),

                    // Account Status Section
                    AccountStatusCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroProfileCard extends StatelessWidget {
  const HeroProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.lightOrangeBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile avatar
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryOrangeGradientStart,
                          AppColors.primaryOrangeGradientEnd,
                        ],
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.backgroundColor,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      height: 23,
                      width: 23,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // Partner information
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rohit Sharma',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor,
                      ),
                    ),

                    SizedBox(height: 7),

                    _HeroInfoRow(
                      icon: Icons.phone_rounded,
                      text: '+91 98765 43210',
                    ),

                    SizedBox(height: 6),

                    _HeroInfoRow(icon: Icons.badge_outlined, text: 'DP100245'),

                    SizedBox(height: 10),

                    // Approval badge
                    _ApprovalBadge(),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bottom illustration and partner message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.lightOrangeBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Partner',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Ready to deliver with confidence!',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(AppImages.deliveryBikeP, height: 65, width: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalBadge extends StatelessWidget {
  const _ApprovalBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.successGreenBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            color: AppColors.successGreenBadge,
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            'Approved Partner',
            style: TextStyle(
              color: AppColors.successGreenBadge,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryOrangeAccent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Profile Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleTextColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(color: AppColors.borderGrey, height: 1),

          const SizedBox(height: 16),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/1077/1077012.png",
            label: 'Full Name',
            value: 'Rohit Sharma',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/15474/15474140.png",
            label: 'Mobile Number',
            value: '+91 98765 43210',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/732/732200.png",
            label: 'Email Address',
            value: 'rohit.sharma@email.com',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/18390/18390769.png",
            label: 'Address',
            value: '24, Anna Nagar, Chennai',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/562/562460.png",
            label: 'City',
            value: 'Chennai',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/684/684908.png",
            label: 'State',
            value: 'Tamil Nadu',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/149/149059.png",
            label: 'PIN Code',
            value: '600040',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class ProfileDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const ProfileDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.darkTextColor),
          const SizedBox(width: 14),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.darkTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleInformationCard extends StatelessWidget {
  const VehicleInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.two_wheeler_rounded,
                  color: AppColors.primaryOrangeAccent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Your registered vehicle details',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoutes.vehicleInformation);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrangeAccent,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.primaryOrangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(color: AppColors.borderGrey, height: 1),

          const SizedBox(height: 18),

          // Vehicle Image Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softOrangeBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primaryOrangeAccent.withValues(alpha: 0.10),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 105,
                  height: 85,
                  child: Image.asset(
                    AppImages.deliveryBikeP,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.two_wheeler_rounded,
                        size: 65,
                        color: AppColors.primaryOrangeAccent,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Activa 6G',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                      const SizedBox(height: 7),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'TN07AB1234',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.primaryOrangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Vehicle Details
          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/9842/9842417.png",
            label: 'Vehicle Type',
            value: 'Bike',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/18544/18544812.png",
            label: 'Registration Number',
            value: 'TN07AB1234',
          ),

          const CustomIconTextRow(
            icon: "https://cdn-icons-png.flaticon.com/128/3148/3148937.png",
            label: 'Vehicle Model',
            value: 'Activa 6G',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class CustomIconTextRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final bool showDivider;

  const CustomIconTextRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(icon, height: 18, width: 18),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextColor,
                  ),
                ),
              ),
            ],
          ),

          if (showDivider) ...[
            const SizedBox(height: 12),
            Divider(color: AppColors.lightBorderGrey, height: 1),
          ],
        ],
      ),
    );
  }
}

class ServiceAreaCard extends StatelessWidget {
  const ServiceAreaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primaryOrangeAccent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Area',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Your assigned delivery locations',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoutes.locationInformation);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrangeAccent,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.primaryOrangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(color: AppColors.borderGrey, height: 1),

          const SizedBox(height: 18),

          // Location Details Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softOrangeBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primaryOrangeAccent.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Map Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            AppImages.location,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: AppColors.placeholderGrey,
                                child: const Icon(
                                  Icons.map_outlined,
                                  size: 35,
                                  color: AppColors.textGrey,
                                ),
                              );
                            },
                          ),
                        ),

                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryOrangeAccent.withValues(
                              alpha: 0.18,
                            ),
                            border: Border.all(
                              color: AppColors.primaryOrangeAccent.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.location_on_rounded,
                          size: 29,
                          color: AppColors.primaryOrangeAccent,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Service Area Information
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ASSIGNED SERVICE AREA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: AppColors.textGrey,
                        ),
                      ),

                      SizedBox(height: 7),

                      Text(
                        'Chennai',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkTextColor,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        'Anna Nagar, T. Nagar, Adyar and nearby areas',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: AppColors.textGreyDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Location Coverage Label
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.successGreen,
              ),

              const SizedBox(width: 7),

              Text(
                'Service coverage active',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.successGreenText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DocumentStatusCard extends StatelessWidget {
  const DocumentStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.primaryOrangeAccent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Document Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Verification status of your documents',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoutes.documentInformation);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrangeAccent,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.primaryOrangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(color: AppColors.borderGrey, height: 1),

          const SizedBox(height: 18),

          // Individual Documents
          const DocumentStatusItem(
            icon: Icons.badge_outlined,
            title: 'Driving Licence',
            subtitle: 'Identity and driving proof',
          ),

          const SizedBox(height: 12),

          const DocumentStatusItem(
            icon: Icons.directions_car_outlined,
            title: 'Vehicle Registration',
            subtitle: 'Registration Certificate (RC)',
          ),

          const SizedBox(height: 12),

          const DocumentStatusItem(
            icon: Icons.assignment_ind_outlined,
            title: 'Identity Proof',
            subtitle: 'Personal identification document',
          ),
        ],
      ),
    );
  }
}

// Individual Document Item
class DocumentStatusItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const DocumentStatusItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardGreyBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: AppColors.iconGreyDark),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successGreenSoftBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 13,
                  color: AppColors.successGreen,
                ),
                SizedBox(width: 4),
                Text(
                  'Verified',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.successGreen,
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

class AccountStatusCard extends StatelessWidget {
  const AccountStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryOrangeAccent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Your account and verification overview',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(color: AppColors.borderGrey, height: 1),

          const SizedBox(height: 18),

          // Account Status Items
          const Row(
            children: [
              Expanded(
                child: AccountStatusItem(
                  icon: Icons.calendar_month_outlined,
                  label: 'Registration',
                  value: 'Active',
                  color: AppColors.successGreen,
                  backgroundColor: AppColors.successGreenSoftBg,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: AccountStatusItem(
                  icon: Icons.verified_user_outlined,
                  label: 'Verification',
                  value: 'Verified',
                  color: AppColors.successGreen,
                  backgroundColor: AppColors.successGreenSoftBg,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Last Updated
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softOrangeBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryOrangeAccent.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    size: 20,
                    color: AppColors.primaryOrangeAccent,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Updated',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '03 Nov 2026, 07:45 PM',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.check_circle_rounded,
                  size: 19,
                  color: AppColors.successGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Account Status Item
class AccountStatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color backgroundColor;

  const AccountStatusItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardGreyBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 19, color: color),
              const Spacer(),
              Icon(Icons.check_circle_rounded, size: 15, color: color),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 7),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
