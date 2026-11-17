import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';

class VerifyPickupScreen extends StatefulWidget {
  const VerifyPickupScreen({super.key});

  @override
  State<VerifyPickupScreen> createState() => _VerifyPickupScreenState();
}

class _VerifyPickupScreenState extends State<VerifyPickupScreen> {
  final FocusNode _otpFocusNode = FocusNode();

  PinTheme _pinTheme({
    required double size,
    Color? borderColor,
    double borderWidth = 1.2,
    List<BoxShadow>? shadows,
  }) {
    return PinTheme(
      width: size,
      height: size + 8,
      textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textColor,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor ?? AppColors.textGrey,
          width: borderWidth,
        ),
        boxShadow: shadows,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _otpFocusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    context.pushNamed(AppRoutes.sellerConfirmation);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = _pinTheme(size: 48);
    final focusedPinTheme = _pinTheme(
      size: 48,
      borderColor: AppColors.primaryOrange,
      borderWidth: 1.8,
    );
    final submittedPinTheme = _pinTheme(
      size: 48,
      borderColor: AppColors.primaryOrange,
    );
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Verify Pickup'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          children: [
            // Store & Order Summary Header Card
            const VerifyStoreHeaderCard(),

            const SizedBox(height: 20),

            Center(child: Image.asset(AppImages.verify)),
            const SizedBox(height: 15),

            // Title & Subtitle
            const Text(
              'Enter Pickup OTP',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Please ask the seller for the pickup verification code to confirm that you have collected the order.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
                height: 1.35,
              ),
            ),

            const SizedBox(height: 24),

            Pinput(
              controller: TextEditingController(),
              focusNode: _otpFocusNode,
              length: 6,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofillHints: const [AutofillHints.oneTimeCode],
              pinAnimationType: PinAnimationType.scale,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              showCursor: true,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              onCompleted: (_) => _verifyOtp(),
            ),

            const SizedBox(height: 18),

            // Resend OTP Button
            ResendOtpButton(onResendTap: () {}),

            const SizedBox(height: 28),

            // Verify Pickup Button
            CustomButton(title: "Verify OTP", onPressed: () {}),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class VerifyStoreHeaderCard extends StatelessWidget {
  const VerifyStoreHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey, width: 1.2),
      ),
      child: Row(
        children: [
          // Storefront graphic
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/128/869/869432.png',
              height: 55,
              width: 55,
            ),
          ),

          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: AppColors.textColor),
                    children: [
                      TextSpan(
                        text: 'Order Reference: ',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                      TextSpan(
                        text: '#SVN10245',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'Seller: ',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                      TextSpan(
                        text: 'ABC Store',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 13,
                      color: AppColors.primaryOrange,
                    ),
                    SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '12, Anna Nagar Main Road, Chennai - 600040',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
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

class ResendOtpButton extends StatelessWidget {
  final VoidCallback onResendTap;

  const ResendOtpButton({super.key, required this.onResendTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onResendTap,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sync_rounded, size: 17, color: AppColors.acceptGreen),
          SizedBox(width: 6),
          Text(
            'Resend OTP',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.acceptGreen,
            ),
          ),
        ],
      ),
    );
  }
}
