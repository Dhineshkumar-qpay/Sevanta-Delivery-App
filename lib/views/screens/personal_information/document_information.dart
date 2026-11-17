import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/constants/enums.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_image.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_snackbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_text_field.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_time_picker.dart';

class DocumentInformation extends StatefulWidget {
  const DocumentInformation({super.key});

  @override
  State<DocumentInformation> createState() => _DocumentInformationState();
}

class _DocumentInformationState extends State<DocumentInformation> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _aadhaarNumberController;

  late TextEditingController _panNumberController;

  late TextEditingController _dlNumberController;
  late TextEditingController _dlExpiryController;

  late TextEditingController _rcNumberController;

  final ValueNotifier<File?> _aadhaarFrontNotifier = ValueNotifier(null);
  final ValueNotifier<File?> _aadhaarBackNotifier = ValueNotifier(null);
  final ValueNotifier<File?> _panCardNotifier = ValueNotifier(null);
  final ValueNotifier<File?> _dlFrontNotifier = ValueNotifier(null);
  final ValueNotifier<File?> _dlBackNotifier = ValueNotifier(null);
  final ValueNotifier<File?> _rcFrontNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _aadhaarNumberController = TextEditingController();
    _panNumberController = TextEditingController();
    _dlNumberController = TextEditingController();
    _dlExpiryController = TextEditingController();
    _rcNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _aadhaarNumberController.dispose();
    _panNumberController.dispose();
    _dlNumberController.dispose();
    _dlExpiryController.dispose();
    _rcNumberController.dispose();

    _aadhaarFrontNotifier.dispose();
    _aadhaarBackNotifier.dispose();
    _panCardNotifier.dispose();
    _dlFrontNotifier.dispose();
    _dlBackNotifier.dispose();
    _rcFrontNotifier.dispose();

    super.dispose();
  }

  Future<void> _pickDocumentImage(
    ValueNotifier<File?> notifier,
    ImageSource source,
  ) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1280,
        maxHeight: 1280,
      );
      if (pickedFile != null && mounted) {
        final croppedFile = await CustomImageCropper.cropImage(
          pickedFile.path,
          isProfile: false,
        );
        if (croppedFile != null) {
          notifier.value = File(croppedFile.path);
        }
      }
    } catch (e) {
      debugPrint('Error picking document image: $e');
    }
  }

  void _showImagePickerSheet(ValueNotifier<File?> notifier) {
    CustomImagePicker.showImagePicker(
      context,
      cameraOnTap: () => _pickDocumentImage(notifier, ImageSource.camera),
      galleryOnTap: () => _pickDocumentImage(notifier, ImageSource.gallery),
    );
  }

  bool _validateUploadedDocuments() {
    if (_aadhaarFrontNotifier.value == null ||
        _aadhaarBackNotifier.value == null) {
      CustomSnackBar.show(
        context: context,
        message:
            'Please upload both front and back images of your Aadhaar Card.',
        type: SnackBarType.error,
      );
      return false;
    }

    if (_panCardNotifier.value == null) {
      CustomSnackBar.show(
        context: context,
        message: 'Please upload a photo of your PAN Card.',
        type: SnackBarType.error,
      );
      return false;
    }

    if (_dlFrontNotifier.value == null || _dlBackNotifier.value == null) {
      CustomSnackBar.show(
        context: context,
        message:
            'Please upload both front and back images of your Driving License.',
        type: SnackBarType.error,
      );
      return false;
    }

    if (_rcFrontNotifier.value == null) {
      CustomSnackBar.show(
        context: context,
        message: 'Please upload your Vehicle Registration Certificate (RC).',
        type: SnackBarType.error,
      );
      return false;
    }

    return true;
  }

  Future<void> handleDocumentSubmit() async {
    if (!_formKey.currentState!.validate()) {
      CustomSnackBar.show(
        context: context,
        message: 'Please fill in all required document numbers.',
        type: SnackBarType.error,
      );
      return;
    }
    if (!_validateUploadedDocuments()) {
      return;
    }
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      CustomSnackBar.show(
        context: context,
        message: 'All documents submitted successfully for verification!',
        type: SnackBarType.success,
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(
        context: context,
        message: 'Failed to submit documents. Please try again.',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Document Information'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            BuildSectionHeader(title: '1. Aadhaar Card Verification'),
            const SizedBox(height: 12),
            CustomTextFormField(
              labelText: 'Aadhaar Number',
              hintText: 'Enter 12-digit Aadhaar number',
              controller: _aadhaarNumberController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              prefixIcon: Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter Aadhaar number';
                }
                if (!RegExp(r'^\d{12}$').hasMatch(value.trim())) {
                  return 'Enter a valid 12-digit Aadhaar number';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DocumentUploadCard(
                    title: 'Aadhaar Front',
                    fileNotifier: _aadhaarFrontNotifier,
                    onTap: () => _showImagePickerSheet(_aadhaarFrontNotifier),
                    onClear: () => _aadhaarFrontNotifier.value = null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DocumentUploadCard(
                    title: 'Aadhaar Back',
                    fileNotifier: _aadhaarBackNotifier,
                    onTap: () => _showImagePickerSheet(_aadhaarBackNotifier),
                    onClear: () => _aadhaarBackNotifier.value = null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            BuildSectionHeader(title: '2. PAN Card Verification'),
            const SizedBox(height: 12),
            CustomTextFormField(
              labelText: 'PAN Card Number',
              hintText: 'e.g., ABCDE1234F',
              controller: _panNumberController,
              prefixIcon: Icons.credit_card_outlined,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter PAN Card number';
                }
                if (!RegExp(
                  r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                ).hasMatch(value.trim().toUpperCase())) {
                  return 'Enter a valid 10-character PAN (e.g. ABCDE1234F)';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _DocumentUploadCard(
              title: 'PAN Card Front Photo',
              fileNotifier: _panCardNotifier,
              onTap: () => _showImagePickerSheet(_panCardNotifier),
              onClear: () => _panCardNotifier.value = null,
            ),

            const SizedBox(height: 25),

            BuildSectionHeader(title: '3. Driving License (DL)'),
            const SizedBox(height: 12),
            CustomTextFormField(
              labelText: 'Driving License Number',
              hintText: 'Enter DL number',
              controller: _dlNumberController,
              prefixIcon: Icons.drive_eta_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter driving license number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              labelText: 'DL Expiry Date',
              hintText: 'DD-MM-YYYY',
              controller: _dlExpiryController,
              readOnly: true,
              suffixIcon: Icons.calendar_month_outlined,
              onTap: () async {
                final pickedDate = await CustomDatePicker.showPickDate(context);
                if (pickedDate != null) {
                  setState(() {
                    _dlExpiryController.text = DateFormat(
                      'dd-MM-yyyy',
                    ).format(pickedDate);
                  });
                }
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select driving license expiry date';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DocumentUploadCard(
                    title: 'DL Front Side',
                    fileNotifier: _dlFrontNotifier,
                    onTap: () => _showImagePickerSheet(_dlFrontNotifier),
                    onClear: () => _dlFrontNotifier.value = null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DocumentUploadCard(
                    title: 'DL Back Side',
                    fileNotifier: _dlBackNotifier,
                    onTap: () => _showImagePickerSheet(_dlBackNotifier),
                    onClear: () => _dlBackNotifier.value = null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            BuildSectionHeader(
              title: '4. Vehicle RC (Registration Certificate)',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              labelText: 'RC Registration Number',
              hintText: 'e.g., TN01AB1234',
              controller: _rcNumberController,
              prefixIcon: Icons.featured_play_list_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter vehicle RC number';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _DocumentUploadCard(
              title: 'Vehicle RC Document / Smart Card Photo',
              fileNotifier: _rcFrontNotifier,
              onTap: () => _showImagePickerSheet(_rcFrontNotifier),
              onClear: () => _rcFrontNotifier.value = null,
            ),

            const SizedBox(height: 25),

            const SizedBox(height: 35),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: CustomButton(
            title: 'Submit Verification',
            isLoading: false,
            onPressed: () {
              context.pushNamed(AppRoutes.mainDashboard);
            },
          ),
        ),
      ),
    );
  }
}

class BuildSectionHeader extends StatelessWidget {
  const BuildSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  const _DocumentUploadCard({
    required this.title,
    required this.fileNotifier,
    required this.onTap,
    required this.onClear,
  });

  final String title;
  final ValueNotifier<File?> fileNotifier;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<File?>(
      valueListenable: fileNotifier,
      builder: (context, file, child) {
        final isUploaded = file != null;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Builder(
              builder: (context) {
                if (isUploaded) {
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Colors.green.shade600,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Uploaded',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: onClear,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.redAccent,
                          size: 15,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          size: 24,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to upload photo',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
