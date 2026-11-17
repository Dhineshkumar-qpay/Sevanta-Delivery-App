import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:sevanta_delivery_partner/utils/extensions/string_extensions.dart';

class CustomDropDownField extends StatelessWidget {
  const CustomDropDownField({
    super.key,
    required this.title,
    required this.valueListenable,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.horizontalPadding = 6,
  });

  final String title;
  final ValueListenable<String?> valueListenable;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        valueListenable: valueListenable,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          fillColor: AppColors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.borderGrey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primaryOrange,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.errorText),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.errorText, width: 1.5),
          ),
        ),

        barrierColor: Colors.transparent,
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down),
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.borderGrey,
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.only(left: 15),
        ),
        hint: Text(
          hintText,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrey,
          ),
        ),

        onChanged: onChanged,
        items: items.map((item) {
          return DropdownItem<String>(
            value: item,
            child: Text(
              item.capitalize(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return items.map((value) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                value.capitalize(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            );
          }).toList();
        },
        validator: validator,
      ),
    );
  }
}
