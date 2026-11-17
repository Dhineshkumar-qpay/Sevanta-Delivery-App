import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/images.dart';
import 'package:sevanta_delivery_partner/utils/constants/text_styles.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_text_field.dart';
import 'package:phone_number_hint/phone_number_hint.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _phoneNumberHintPlugin = PhoneNumberHint();

  final TextEditingController _mobileController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    getPhoneNumber();
    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final mobileNumber = _mobileController.text.trim();

    context.pushNamed(AppRoutes.verifyOTP, extra: mobileNumber);
    try {
      debugPrint('Mobile Number: +91$mobileNumber');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {}
  }

  Future<void> getPhoneNumber() async {
    String result = '';
    try {
      result = await _phoneNumberHintPlugin.requestHint() ?? '';
      final digitsOnly = result.replaceAll(RegExp(r'\D'), '');
      final last10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;
      if (!mounted) return;
      _mobileController.text = last10;
      if (mounted) setState(() {});
    } on PlatformException {
      result = 'Failed to get hint.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
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

            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      AppImages.appLogo,
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Welcome to\n",
                            style: TextStyle(color: AppColors.textColor),
                          ),
                          TextSpan(
                            text: "Sevanta Delivery",
                            style: TextStyle(color: AppColors.primaryOrange),
                          ),
                        ],
                        style: AppTextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryOrange,
                        ).textStyle,
                      ),
                    ),
                    const SizedBox(height: 14),
                    BodyTextHint(title: "Login to continue", fontSize: 14),
                    const SizedBox(height: 45),
                    CustomTextFormField(
                      controller: _mobileController,
                      labelText: 'Mobile Number',
                      hintText: 'Enter 10-digit number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.phone_android_rounded,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
                          return 'Enter a valid 10-digit mobile number';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomButton(title: 'Get OTP', onPressed: _handleLogin),
                    const SizedBox(height: 30),
                    Center(
                      child: Column(
                        children: [
                          BodyTextHint(
                            title: 'Delivering Happiness, One Order at a Time.',
                            textAlign: TextAlign.center,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 15),
                          HeaderTextBlack(
                            title:
                                'By continuing, you agree to our '
                                'Terms & Privacy Policy.',
                            textAlign: TextAlign.center,
                            fontSize: 11,
                          ),
                        ],
                      ),
                    ),
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
