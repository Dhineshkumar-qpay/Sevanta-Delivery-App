import 'package:flutter/material.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';

class CustomDatePicker {
  static Future<DateTime?> showPickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: AppColors.white,
              onSurface: Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: AppColors.primaryOrange,
              headerForegroundColor: AppColors.white,
              backgroundColor: AppColors.white,
              weekdayStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              dayStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryOrange,
              ),
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
          ),
          child: child!,
        );
      },
    );

    return pickedDate;
  }
}
