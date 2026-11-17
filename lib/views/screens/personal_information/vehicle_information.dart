import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_appbar.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_button.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_drop_downs.dart';
import 'package:sevanta_delivery_partner/views/widgets/custom_text_field.dart';

class VehicleInformation extends StatefulWidget {
  const VehicleInformation({super.key});

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<String?> _vehicleTypeNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _vehicleCategoryNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _brandNotifier = ValueNotifier(null);

  late TextEditingController _vehicleNumberController;
  late TextEditingController _modelController;
  late TextEditingController _colorController;
  late TextEditingController _yearController;

  final List<String> _vehicleTypes = [
    'Bike',
    'Scooter',
    'EV / Electric',
    'Bicycle',
  ];

  final List<String> _vehicleCategories = [
    'Two Wheeler',
    'Three Wheeler',
    'Four Wheeler',
    'Bicycle',
  ];

  final List<String> _brands = [
    'Hero',
    'Honda',
    'Bajaj',
    'TVS',
    'Yamaha',
    'Royal Enfield',
    'Ather',
    'Ola Electric',
    'Suzuki',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    _vehicleNumberController = TextEditingController();
    _modelController = TextEditingController();
    _colorController = TextEditingController();
    _yearController = TextEditingController();
  }

  @override
  void dispose() {
    _vehicleTypeNotifier.dispose();
    _vehicleCategoryNotifier.dispose();
    _brandNotifier.dispose();

    _vehicleNumberController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _yearController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Vehicle Information'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            CustomDropDownField(
              title: 'Vehicle Type',
              valueListenable: _vehicleTypeNotifier,
              items: _vehicleTypes,
              hintText: 'Select vehicle type',
              onChanged: (value) {
                _vehicleTypeNotifier.value = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select vehicle type';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomDropDownField(
              title: 'Vehicle Category',
              valueListenable: _vehicleCategoryNotifier,
              items: _vehicleCategories,
              hintText: 'Select vehicle category',
              onChanged: (value) {
                _vehicleCategoryNotifier.value = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select vehicle category';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              labelText: 'Vehicle Registration Number',
              hintText: 'e.g., TN 00 AB 1234',
              controller: _vehicleNumberController,
              prefixIcon: Icons.confirmation_number_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter vehicle registration number';
                }
                if (value.trim().length < 6) {
                  return 'Please enter a valid registration number';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomDropDownField(
              title: 'Vehicle Brand / Manufacturer',
              valueListenable: _brandNotifier,
              items: _brands,
              hintText: 'Select vehicle brand',
              onChanged: (value) {
                _brandNotifier.value = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select vehicle brand';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              labelText: 'Vehicle Model',
              hintText: 'e.g., Activa, Splendor, Jupiter',
              controller: _modelController,
              prefixIcon: Icons.two_wheeler_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter vehicle model';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              labelText: 'Vehicle Color',
              hintText: 'e.g., Black, Red, Blue',
              controller: _colorController,
              prefixIcon: Icons.color_lens_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter vehicle color';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            CustomTextFormField(
              labelText: 'Manufacturing Year',
              hintText: 'e.g., 2022',
              controller: _yearController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              prefixIcon: Icons.calendar_today_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter manufacturing year';
                }

                final year = int.tryParse(value.trim());

                if (year == null || year < 1990 || year > DateTime.now().year) {
                  return 'Enter a valid manufacturing year';
                }

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
              context.pushNamed(AppRoutes.documentInformation);
            },
          ),
        ),
      ),
    );
  }
}
