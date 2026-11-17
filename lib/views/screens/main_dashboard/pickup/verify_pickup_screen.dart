import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';
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
        fontWeight: FontWeight.w600,
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
            const SizedBox(height: 20),
            Center(child: Image.asset(AppImages.verify)),
            const SizedBox(height: 15),

            // Title & Subtitle
            HeaderTextBlack(
              title: 'Enter Pickup OTP',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 6),

            BodyTextHint(
              title:
                  'Please ask the seller for the pickup verification code to confirm that you have collected the order.',
              textAlign: TextAlign.center,
              fontSize: 12,
            ),

            const SizedBox(height: 25),
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
          BodyTextColors(
            title: 'Resend OTP',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.acceptGreen,
          ),
        ],
      ),
    );
  }
}
