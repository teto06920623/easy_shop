import 'package:easy_shop/core/helpers/location_helper.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:easy_shop/features/profile/presentation/admin/cubit/admin_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/admin/cubit/admin_profile_state.dart';
import 'package:easy_shop/features/profile/presentation/client/widgets/profile_avatar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_shop/features/profile/domain/entities/profile_entity.dart';

class AdminEditProfileScreen extends StatefulWidget {
  final ProfileEntity user;

  const AdminEditProfileScreen({super.key, required this.user});

  @override
  State<AdminEditProfileScreen> createState() => _AdminEditProfileScreenState();
}

class _AdminEditProfileScreenState extends State<AdminEditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _businessNameController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _businessAddressController;

  String? _newPicturePath;
  double? _latitude;
  double? _longitude;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _businessNameController = TextEditingController(
      text: widget.user.businessName ?? '',
    );
    _nationalIdController = TextEditingController(
      text: widget.user.nationalId ?? '',
    );
    _businessAddressController = TextEditingController(
      text: widget.user.address ?? '',
    );
    _latitude = widget.user.latitude;
    _longitude = widget.user.longitude;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _nationalIdController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _newPicturePath = picked.path);
    }
  }

  Future<void> _fetchLocation() async {
    final res = await LocationHelper.getCurrentCityAndLocation();
    if (res != null) {
      setState(() {
        _latitude = res.latitude;
        _longitude = res.longitude;
        _businessAddressController.text = res.cityName;
      });
    }
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final businessName = _businessNameController.text.trim();

    if (name.isEmpty || businessName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name and Business Name are required'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<AdminProfileCubit>().updateProfile(
      name: name,
      picturePath: _newPicturePath,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      businessName: businessName,
      nationalId: _nationalIdController.text.trim(),
      address: _businessAddressController.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminProfileCubit, AdminProfileState>(
      listener: (context, state) {
        if (state is AdminProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Merchant profile updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else if (state is AdminProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AdminProfileLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Edit Merchant Profile'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfileAvatarPicker(
                    initialImageUrl: widget.user.pictureUrl,
                    localImagePath: _newPicturePath,
                    initials: widget.user.name.isNotEmpty
                        ? widget.user.name[0].toUpperCase()
                        : 'M',
                    onPickImage: _pickImage,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Full Name',
                    hint: '',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Email',
                    hint: '',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Phone',
                    hint: '',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Business Name *',
                    hint: '',
                    controller: _businessNameController,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'National ID *',
                    hint: '',
                    controller: _nationalIdController,
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Business Address',
                    hint: '',
                    controller: _businessAddressController,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.my_location,
                        color: AppColors.primary,
                      ),
                      onPressed: _fetchLocation,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    title: 'Save Changes',
                    isLoading: isLoading,
                    onPressed: _onSave,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
