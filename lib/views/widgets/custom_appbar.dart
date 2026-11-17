import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final bool isLeading;
  final List<Widget>? actions;
  final double elevation;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.isLeading = true,
    this.actions,
    this.elevation = 0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      toolbarHeight: 64,
      leadingWidth: isLeading ? 64 : null,
      leading: isLeading
          ? InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AppColors.textColor,
              ),
            )
          : null,
      title: HeaderTextBlack(
        title: title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(children: [Image.asset(AppImages.appbarBgP)]),
      ),
      actions: actions == null
          ? null
          : [...actions!, const SizedBox(width: 12)],

      shape: const Border(
        bottom: BorderSide(color: Color(0xFFECEFF3), width: 0.7),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.size = 30,
    this.strokeWidth = 3,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomErrorTextWidget extends StatelessWidget {
  const CustomErrorTextWidget({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 45, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
