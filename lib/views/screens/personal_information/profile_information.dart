import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_drop_downs.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_image.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_text_field.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_time_picker.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<File?> profileImageNotifier = ValueNotifier(null);
  final valueListenable = ValueNotifier<String?>(null);

  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController dateOfBirthController;

  String? gender;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();
    dateOfBirthController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();

    profileImageNotifier.dispose();
    valueListenable.dispose();

    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile != null && mounted) {
        CroppedFile? croppedFile = await CustomImageCropper.cropImage(
          pickedFile.path,
        );
        if (croppedFile != null) {
          profileImageNotifier.value = File(croppedFile.path);
        }
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Profile Information'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const SizedBox(height: 15),
            Center(
              child: ValueListenableBuilder<File?>(
                valueListenable: profileImageNotifier,
                builder: (context, image, child) {
                  return GestureDetector(
                    onTap: () {
                      CustomImagePicker.showImagePicker(
                        context,
                        cameraOnTap: () {
                          _pickImage(ImageSource.camera);
                        },
                        galleryOnTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: image != null
                              ? FileImage(image)
                              : null,
                          child: image == null
                              ? Image.network(
                                  "https://cdn-icons-png.flaticon.com/128/1077/1077012.png",
                                  height: 50,
                                )
                              : null,
                        ),

                        Positioned(
                          bottom: 0,
                          right: -10,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            CustomTextFormField(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              controller: nameController,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              labelText: 'Mobile Number',
              hintText: 'Enter mobile number',
              controller: mobileController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter mobile number';
                }
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                  return 'Enter a valid 10-digit mobile number';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              labelText: 'Email Address',
              hintText: 'Enter email address',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_sharp,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email address';
                }
                if (!RegExp(
                  r'^[\w\.-]+@[\w\.-]+\.\w+$',
                ).hasMatch(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              labelText: 'Date of Birth',
              hintText: 'DD/MM/YYYY',
              controller: dateOfBirthController,
              readOnly: true,
              onTap: () async {
                final pickedDate = await CustomDatePicker.showPickDate(context);
                if (pickedDate != null) {
                  setState(() {
                    dateOfBirthController.text = DateFormat(
                      'dd-MM-yyyy',
                    ).format(pickedDate);
                  });
                }
              },
              suffixIcon: Icons.calendar_month_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select date of birth';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomDropDownField(
              title: 'Gender',
              valueListenable: valueListenable,
              items: ["Male", "Female", "Transgender"],
              onChanged: (value) {
                valueListenable.value = value;
              },
              hintText: "Select gender",
              validator: (value) {
                if (value == null) return "Please select gender";
                return null;
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: CustomButton(
            title: 'Next',
            onPressed: () {
              context.pushNamed(AppRoutes.locationInformation);
            },
          ),
        ),
      ),
    );
  }
}
