import 'dart:async';
import 'package:easy_shop/core/di/injection_container.dart';
import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/features/auth/presentation/admin/cubit/admin_auth_cubit.dart';
import 'package:easy_shop/features/auth/presentation/admin/cubit/admin_auth_state.dart';
import 'package:easy_shop/features/auth/presentation/client/cubit/auth_cubit.dart';
import 'package:easy_shop/features/auth/presentation/client/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/otp_input_fields.dart';
import '../widgets/otp_timer_resend_section.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final String role;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.role = 'client',
  });

  @override
  Widget build(BuildContext context) {
    if (role == 'admin') {
      return BlocProvider(
        create: (_) => sl<AdminAuthCubit>(),
        child: _OtpVerificationBody(email: email, role: role),
      );
    } else {
      return BlocProvider(
        create: (_) => sl<ClientAuthCubit>(),
        child: _OtpVerificationBody(email: email, role: role),
      );
    }
  }
}

class _OtpVerificationBody extends StatefulWidget {
  final String email;
  final String role;

  const _OtpVerificationBody({required this.email, required this.role});

  @override
  State<_OtpVerificationBody> createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<_OtpVerificationBody>
    with WidgetsBindingObserver {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _remainingSeconds = 600;
  Timer? _timer;
  String _lastCheckedClipboard = '';
  bool _hasLeftApp = false;

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCountdown();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _hasLeftApp = true;
    } else if (state == AppLifecycleState.resumed && _hasLeftApp) {
      _hasLeftApp = false;
      _checkClipboardForOtp();
    }
  }

  Future<void> _checkClipboardForOtp() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final rawText = data?.text?.trim() ?? '';
      if (rawText.isEmpty || rawText == _lastCheckedClipboard) return;

      final digits = rawText.replaceAll(RegExp(r'\D'), '');
      if (digits.length == 6) {
        _lastCheckedClipboard = rawText;
        for (int i = 0; i < 6; i++) {
          _controllers[i].text = digits[i];
        }
        if (mounted) {
          setState(() {});
          _checkAndAutoVerify();
        }
      }
    } catch (_) {}
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _remainingSeconds = 600);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _checkAndAutoVerify() {
    if (_enteredOtp.length == 6) {
      FocusScope.of(context).unfocus();
      _onVerify();
    }
  }

  void _handleOtpChange(String value, int index) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 1) {
      if (digits.length >= 4 || index == 0) {
        for (int i = 0; i < 6; i++) {
          if (i < digits.length) {
            _controllers[i].text = digits[i];
          } else {
            _controllers[i].clear();
          }
        }
        setState(() {});
        if (digits.length >= 6) {
          _checkAndAutoVerify();
        } else {
          _focusNodes[digits.length].requestFocus();
        }
        return;
      } else {
        final lastChar = digits.substring(digits.length - 1);
        _controllers[index].text = lastChar;
        if (index < 5) {
          _focusNodes[index + 1].requestFocus();
        }
        setState(() {});
        _checkAndAutoVerify();
        return;
      }
    }

    if (digits.isNotEmpty) {
      _controllers[index].text = digits;
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (digits.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {});
    _checkAndAutoVerify();
  }

  void _onVerify() {
    final code = _enteredOtp;
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (widget.role == 'admin') {
      context.read<AdminAuthCubit>().verifyOtp(email: widget.email, otp: code);
    } else {
      context.read<ClientAuthCubit>().verifyOtp(email: widget.email, otp: code);
    }
  }

  void _onResend() {
    if (widget.role == 'admin') {
      context.read<AdminAuthCubit>().resendOtp(email: widget.email);
    } else {
      context.read<ClientAuthCubit>().resendOtp(email: widget.email);
    }
    _startCountdown();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == 'admin') {
      return BlocConsumer<AdminAuthCubit, AdminAuthState>(
        listener: (context, state) {
          if (state is AdminAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AdminOtpVerifiedSuccess) {
            Navigator.pushReplacementNamed(
              context,
              Routes.welcomeSuccess,
              arguments: 'admin',
            );
          } else if (state is AdminOtpSentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code resent successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) => _buildScaffold(state is AdminAuthLoading),
      );
    } else {
      return BlocConsumer<ClientAuthCubit, ClientAuthState>(
        listener: (context, state) {
          if (state is ClientAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is ClientOtpVerifiedSuccess) {
            Navigator.pushReplacementNamed(
              context,
              Routes.welcomeSuccess,
              arguments: 'client',
            );
          } else if (state is ClientOtpSentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code resent successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) => _buildScaffold(state is ClientAuthLoading),
      );
    }
  }

  Widget _buildScaffold(bool isLoading) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verify Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Check your email',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent a 6-digit verification code to\n${widget.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      OtpInputFields(
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                        onChanged: _handleOtpChange,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        title: 'Verify',
                        isLoading: isLoading,
                        onPressed: _onVerify,
                      ),
                      const SizedBox(height: 20),
                      OtpTimerResendSection(
                        formattedTime: _formattedTime,
                        onResend: _onResend,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
