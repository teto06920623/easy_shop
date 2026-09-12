import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ClientAddressPickerField extends StatelessWidget {
  final TextEditingController addressController;
  final VoidCallback onFetchCurrentLocation;
  final VoidCallback? onOpenMap;

  const ClientAddressPickerField({
    super.key,
    required this.addressController,
    required this.onFetchCurrentLocation,
    this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Address',
          hint: 'Street, City',
          controller: addressController,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
            ),
            onPressed: onFetchCurrentLocation,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: onFetchCurrentLocation,
              icon: const Icon(
                Icons.my_location,
                size: 14,
                color: AppColors.primary,
              ),
              label: const Text(
                'Get Current Location',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
            if (onOpenMap != null)
              TextButton.icon(
                onPressed: onOpenMap,
                icon: const Icon(
                  Icons.map_outlined,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                label: const Text(
                  'Pick on Map',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),
          ],
        ),
      ],
    );
  }
}
