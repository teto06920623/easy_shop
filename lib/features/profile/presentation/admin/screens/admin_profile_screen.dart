import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/features/profile/presentation/admin/cubit/admin_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/admin/cubit/admin_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_edit_profile_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminProfileCubit>().getProfile();
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'M';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminProfileCubit, AdminProfileState>(
      listener: (context, state) {
        if (state is AdminLoggedOutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.clientLogin,
            (route) => false,
          );
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
        if (state is AdminProfileLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final user = (state is AdminProfileLoaded)
            ? state.user
            : (state is AdminProfileUpdateSuccess ? state.user : null);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<AdminProfileCubit>().getProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      MediaQuery.of(context).padding.top + 20,
                      20,
                      24,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          backgroundImage: user?.pictureUrl != null
                              ? NetworkImage(user!.pictureUrl!)
                              : null,
                          child: user?.pictureUrl == null
                              ? Text(
                                  _getInitials(user?.name ?? 'M'),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user?.name ?? 'Merchant',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (user?.businessName != null)
                          Text(
                            user!.businessName!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'MERCHANT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('PERSONAL INFORMATION'),
                        const SizedBox(height: 8),
                        _buildCard([
                          _buildRow(
                            Icons.person_outline,
                            'Full Name',
                            user?.name ?? '-',
                          ),
                          const Divider(height: 20),
                          _buildRow(
                            Icons.email_outlined,
                            'Email',
                            user?.email ?? '-',
                          ),
                          const Divider(height: 20),
                          _buildRow(
                            Icons.phone_outlined,
                            'Phone',
                            user?.phone ?? '-',
                          ),
                          const Divider(height: 20),
                          _buildRow(
                            Icons.badge_outlined,
                            'National ID',
                            user?.nationalId ?? '-',
                          ),
                        ]),
                        const SizedBox(height: 18),
                        _buildSectionHeader('BUSINESS INFORMATION'),
                        const SizedBox(height: 8),
                        _buildCard([
                          _buildRow(
                            Icons.storefront_outlined,
                            'Business Name',
                            user?.businessName ?? '-',
                          ),
                          const Divider(height: 20),
                          _buildRow(
                            Icons.business_outlined,
                            'Business Address',
                            user?.address ?? '-',
                          ),
                        ]),
                        const SizedBox(height: 24),
                        CustomButton(
                          title: 'Edit Profile',
                          onPressed: () async {
                            if (user != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<AdminProfileCubit>(),
                                    child: AdminEditProfileScreen(user: user),
                                  ),
                                ),
                              );
                              if (context.mounted) {
                                context.read<AdminProfileCubit>().getProfile();
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.error),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () =>
                                context.read<AdminProfileCubit>().logout(),
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: AppColors.error,
                              size: 18,
                            ),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.1,
        fontWeight: FontWeight.bold,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
