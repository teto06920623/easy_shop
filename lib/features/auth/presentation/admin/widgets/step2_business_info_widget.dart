import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class Step2BusinessInfoWidget extends StatelessWidget {
  final TextEditingController businessNameController;
  final TextEditingController businessAddressController;
  final String? selectedLocation;
  final String? uploadedCommercialRegister;
  final String? uploadedTaxCard;
  final VoidCallback onPickLocation;
  final VoidCallback onFetchCurrentLocation;
  final bool isFetchingLocation;
  final VoidCallback onUploadCommercialRegister;
  final VoidCallback onRemoveCommercialRegister;
  final VoidCallback onUploadTaxCard;
  final VoidCallback onRemoveTaxCard;

  const Step2BusinessInfoWidget({
    super.key,
    required this.businessNameController,
    required this.businessAddressController,
    this.selectedLocation,
    this.uploadedCommercialRegister,
    this.uploadedTaxCard,
    required this.onPickLocation,
    required this.onFetchCurrentLocation,
    this.isFetchingLocation = false,
    required this.onUploadCommercialRegister,
    required this.onRemoveCommercialRegister,
    required this.onUploadTaxCard,
    required this.onRemoveTaxCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 18),
        CustomTextField(
          label: 'Business Name',
          hint: 'My Digital Store',
          controller: businessNameController,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Business Address (Optional)',
          hint: 'Street, City',
          controller: businessAddressController,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
            ),
            onPressed: onFetchCurrentLocation,
          ),
        ),
        const SizedBox(height: 14),

        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Store Location (Optional)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: isFetchingLocation ? null : onFetchCurrentLocation,
              icon: isFetchingLocation
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(
                      Icons.my_location,
                      size: 14,
                      color: AppColors.primary,
                    ),
              label: const Text(
                'Auto Detect',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
        ),
        const SizedBox(height: 6),

        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedLocation != null
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: selectedLocation != null
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: onPickLocation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      selectedLocation ?? 'Tap to pick on map',
                      style: TextStyle(
                        fontSize: 13,
                        color: selectedLocation != null
                            ? AppColors.textDark
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Get Current Location',
                icon: const Icon(
                  Icons.my_location,
                  size: 20,
                  color: AppColors.primary,
                ),
                onPressed: onFetchCurrentLocation,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        
        const Text(
          'Commercial Register (Optional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        _buildUploadField(
          isUploaded: uploadedCommercialRegister != null,
          title: uploadedCommercialRegister ?? 'Upload Commercial Register',
          onTap: onUploadCommercialRegister,
          onRemove: onRemoveCommercialRegister,
        ),
        const SizedBox(height: 14),

        
        const Text(
          'Tax Card (Optional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        _buildUploadField(
          isUploaded: uploadedTaxCard != null,
          title: uploadedTaxCard ?? 'Upload Tax Card',
          onTap: onUploadTaxCard,
          onRemove: onRemoveTaxCard,
        ),
      ],
    );
  }

  Widget _buildUploadField({
    required bool isUploaded,
    required String title,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isUploaded ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isUploaded ? Icons.check : Icons.upload_file_outlined,
              size: 18,
              color: isUploaded ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: isUploaded ? AppColors.primary : AppColors.textMuted,
                  fontWeight: isUploaded ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isUploaded)
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
