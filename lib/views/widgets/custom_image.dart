import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';

class CustomImageCropper {
  static Future<CroppedFile?> cropImage(
    String imagePath, {
    bool isProfile = false,
  }) async {
    try {
      return await ImageCropper().cropImage(
        sourcePath: imagePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Sevanta Delivery Partner',
            toolbarColor: AppColors.primaryOrange,
            activeControlsWidgetColor: AppColors.primaryOrange,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            cropStyle: isProfile ? CropStyle.circle : CropStyle.rectangle,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    }
  }
}

class CustomImagePicker {
  static Future<void> showImagePicker(
    BuildContext context, {
    required VoidCallback cameraOnTap,
    required VoidCallback galleryOnTap,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Choose Photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close, size: 21),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Select an option to upload your profile picture.',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
                const SizedBox(height: 20),
                BuildOption(
                  icon: "https://cdn-icons-png.flaticon.com/128/846/846799.png",
                  title: 'Take a Photo',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    cameraOnTap();
                  },
                ),

                const SizedBox(height: 12),
                BuildOption(
                  icon:
                      "https://cdn-icons-png.flaticon.com/128/2659/2659360.png",
                  title: 'Choose from Gallery',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    galleryOnTap();
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BuildOption extends StatelessWidget {
  const BuildOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Image.network(icon, height: 25, width: 25),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}
