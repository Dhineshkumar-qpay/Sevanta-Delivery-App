import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _loaderController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    initializePage();
  }

  @override
  void dispose() {
    _controller.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  Future<void> initializePage() async {
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        context.pushReplacement(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.splashBg, fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * .1),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOrange.withValues(
                                  alpha: 0.22,
                                ),
                                blurRadius: 55,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            AppImages.appLogo,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 28),

                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.4),
                            end: Offset.zero,
                          ).animate(_fadeAnimation),
                          child: const SevantaRichText(),
                        ),
                        SizedBox(height: size.height * .1),
                        Column(
                          children: [
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryOrange,
                                ),
                                backgroundColor: AppColors.black.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            BodyTextHint(
                              title: 'Getting things ready...',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
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

class SevantaRichText extends StatelessWidget {
  const SevantaRichText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Sevanta',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          TextSpan(
            text: ' Delivery Partner',
            style: TextStyle(color: AppColors.primaryOrange),
          ),
        ],
        style: AppTextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryOrange,
        ).textStyle,
      ),
    );
  }
}
