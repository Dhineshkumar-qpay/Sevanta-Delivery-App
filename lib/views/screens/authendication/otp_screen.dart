import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _resendSeconds = 30;
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final ValueNotifier<int> _secondsLeft = ValueNotifier<int>(_resendSeconds);
  final ValueNotifier<bool> _isResending = ValueNotifier<bool>(false);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft.value <= 1) {
        timer.cancel();
        _secondsLeft.value = 0;
      } else {
        _secondsLeft.value--;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    _secondsLeft.dispose();
    _isResending.dispose();

    super.dispose();
  }

  Future<void> _verifyOtp() async {
    context.pushReplacement(AppRoutes.personalInformation);
  }

  Future<void> _resendOtp() async {}

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textColor,
            size: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(AppImages.loginBottom, fit: BoxFit.cover),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Image.asset(AppImages.verify)),
                    Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter the 6-digit code we sent to '
                      '+91 ${widget.mobileNumber}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Pinput(
                      controller: _otpController,
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
                    const SizedBox(height: 35),
                    CustomButton(
                      title: "Verify & Continue",
                      onPressed: _verifyOtp,
                    ),

                    const SizedBox(height: 28),

                    Center(
                      child: ValueListenableBuilder<int>(
                        valueListenable: _secondsLeft,
                        builder: (context, seconds, child) {
                          final m = (seconds ~/ 60).toString().padLeft(2, '0');
                          final s = (seconds % 60).toString().padLeft(2, '0');
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: seconds > 0
                                ? Row(
                                    key: const ValueKey('timer'),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 16,
                                        color: AppColors.textGrey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Resend code in ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      Text(
                                        '$m:$s',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    key: const ValueKey('resend'),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Didn’t receive the OTP?',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _isResending,
                                        builder: (context, isResending, child) {
                                          return TextButton(
                                            onPressed: isResending
                                                ? null
                                                : _resendOtp,
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              minimumSize: const Size(0, 36),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Text(
                                              isResending
                                                  ? 'Sending...'
                                                  : 'Resend OTP',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.primaryOrange,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
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
