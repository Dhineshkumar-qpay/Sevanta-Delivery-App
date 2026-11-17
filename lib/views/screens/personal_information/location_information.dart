import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_text_field.dart';

class LocationInformation extends StatefulWidget {
  const LocationInformation({super.key});

  @override
  State<LocationInformation> createState() => _LocationInformationState();
}

class _LocationInformationState extends State<LocationInformation> {
  late TextEditingController doorNoController;
  late TextEditingController streetNameController;
  late TextEditingController addressController;
  late TextEditingController pincodeController;

  final List<String> locationChip = ["Home", "Office", "Other"];

  int selectedChip = 0;

  @override
  void initState() {
    super.initState();

    doorNoController = TextEditingController();
    streetNameController = TextEditingController();
    addressController = TextEditingController();
    pincodeController = TextEditingController();
  }

  @override
  void dispose() {
    doorNoController.dispose();
    streetNameController.dispose();
    addressController.dispose();
    pincodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Address Information'),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: List.generate(
                locationChip.length,
                (index) => Expanded(
                  child: LocationChip(
                    title: locationChip[index],
                    isSelect: selectedChip == index,
                    onTap: () {
                      setState(() {
                        selectedChip = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: doorNoController,
            labelText: "Door Number/House Number",
            hintText: "Enter door number",
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: streetNameController,
            labelText: "Street Name",
            hintText: "Enter street name",
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: addressController,
                  labelText: "Address",
                  maxLines: 3,
                  readOnly: true,
                  hintText: "Select your location",
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  var result = await context.pushNamed(AppRoutes.pickLocation);
                  if (result != null) {
                    final data = result as Map<String, dynamic>;
                    addressController.text = data['address'] as String;
                    pincodeController.text = data['pincode'] as String;
                    // = data['latitude'] as double;
                    // = data['longitude'] as double;
                    setState(() {});
                  }
                },
                child: Container(
                  width: 90,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primaryOrange.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://cdn-icons-png.flaticon.com/128/1946/1946770.png',
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.location_on_outlined,
                            size: 40,
                            color: AppColors.primaryOrange,
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Edit Location",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: pincodeController,
            labelText: "Pincode",
            hintText: "Enter pincode",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: CustomButton(
            title: 'Next',
            onPressed: () {
              context.pushNamed(AppRoutes.vehicleInformation);
            },
          ),
        ),
      ),
    );
  }
}

class LocationChip extends StatelessWidget {
  const LocationChip({
    super.key,
    required this.title,
    required this.isSelect,
    required this.onTap,
  });

  final String title;
  final bool isSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelect ? AppColors.primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelect) ...[
              const Icon(Icons.check_circle, size: 16, color: AppColors.white),
              const SizedBox(width: 6),
            ],

            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelect ? AppColors.white : AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
