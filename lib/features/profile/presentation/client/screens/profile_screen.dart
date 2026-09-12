import 'package:easy_shop/core/helpers/secure_storage_helper.dart';
import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/features/maps/presentation/client/screens/map_picker_screen.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_state.dart';
import 'package:easy_shop/features/profile/presentation/client/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientProfileCubit>().getProfile();
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await SecureStorageHelper.logout();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.clientLogin,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<ClientProfileCubit, ClientProfileState>(
        builder: (context, state) {
          final user = (state is ClientProfileLoaded)
              ? state.user
              : (state is ClientProfileUpdateSuccess ? state.user : null);

          final name = user?.name.isNotEmpty == true
              ? user!.name
              : 'Ahmed Hassan';
          final email = user?.email.isNotEmpty == true
              ? user!.email
              : 'ahmed@example.com';
          final phone = user?.phone?.isNotEmpty == true
              ? user!.phone!
              : '+20 100 000 0000';
          final pictureUrl = user?.pictureUrl;
          final initials = _getInitials(name);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary,
                        backgroundImage:
                            (pictureUrl != null && pictureUrl.isNotEmpty)
                            ? NetworkImage(pictureUrl)
                            : null,
                        child: (pictureUrl == null || pictureUrl.isEmpty)
                            ? Text(
                                initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Information',
                        onTap: () {
                          _goToEditProfile(context);
                        },
                      ),
                      const Divider(
                        height: 1,
                        indent: 52,
                        color: Color(0xFFF2F2F2),
                      ),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Delivery Address',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MapPickerScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        height: 1,
                        indent: 52,
                        color: Color(0xFFF2F2F2),
                      ),
                      _buildMenuItem(
                        icon: Icons.inventory_2_outlined,
                        title: 'My Orders',
                        onTap: () {
                          
                          Navigator.pushNamed(context, Routes.clientMainNav);
                        },
                      ),
                      const Divider(
                        height: 1,
                        indent: 52,
                        color: Color(0xFFF2F2F2),
                      ),
                      _buildMenuItem(
                        icon: Icons.favorite_border_rounded,
                        title: 'Favorites',
                        onTap: () {
                          Navigator.pushNamed(context, Routes.clientMainNav);
                        },
                      ),
                      const Divider(
                        height: 1,
                        indent: 52,
                        color: Color(0xFFF2F2F2),
                      ),
                      _buildMenuItem(
                        icon: Icons.edit_outlined,
                        title: 'Edit Profile',
                        onTap: () => _goToEditProfile(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _handleLogout,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 18,
                          color: Color(0xFFE53935),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _goToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ClientProfileCubit>(),
          child: const EditProfileScreen(),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFBDBDBD),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
