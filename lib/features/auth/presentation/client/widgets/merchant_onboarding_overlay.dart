import 'dart:async';
import 'package:flutter/material.dart';

import 'onboarding_components/onboarding_bot_dialog.dart';
import 'onboarding_components/onboarding_create_account_target.dart';
import 'onboarding_components/onboarding_merchant_target.dart';
import 'onboarding_components/onboarding_skip_button.dart';

class MerchantOnboardingOverlay extends StatefulWidget {
  final GlobalKey merchantKey;
  final GlobalKey createAccountKey;
  final VoidCallback onDismiss;

  const MerchantOnboardingOverlay({
    super.key,
    required this.merchantKey,
    required this.createAccountKey,
    required this.onDismiss,
  });

  @override
  State<MerchantOnboardingOverlay> createState() =>
      _MerchantOnboardingOverlayState();
}

class _MerchantOnboardingOverlayState extends State<MerchantOnboardingOverlay>
    with TickerProviderStateMixin {
  int _step = 1;

  String _displayedText = '';
  Timer? _typewriterTimer;

  final Map<int, String> _stepTexts = {
    1: "Hello! Welcome to Easy Shop 🎉\n\nIf you already have an account, enter your credentials to start shopping!",
    2: "First time here? ✨\n\nTap on 'Create Account' below to register your new shopping account in seconds!",
    3: "Are you a store owner or seller? 🚀\n\nTap on the 'Merchant Portal' above to access your business dashboard!",
  };

  late AnimationController _characterController;
  late Animation<Offset> _characterSlideAnimation;

  late AnimationController _pointerPulseController;
  late Animation<double> _pulseAnimation;

  Rect? _getWidgetRect(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;
    final offset = renderBox.localToGlobal(Offset.zero);
    return offset & renderBox.size;
  }

  @override
  void initState() {
    super.initState();

    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _characterSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _characterController,
            curve: Curves.easeOutCubic,
          ),
        );

    _pointerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _pointerPulseController, curve: Curves.easeInOut),
    );

    _characterController.forward();
    _startTypewriter(_stepTexts[1]!);
  }

  void _startTypewriter(String fullText) {
    _typewriterTimer?.cancel();
    setState(() => _displayedText = '');

    final characters = fullText.characters;
    final totalCount = characters.length;
    int currentIndex = 0;

    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 18), (
      timer,
    ) {
      if (currentIndex < totalCount) {
        setState(() {
          currentIndex++;
          _displayedText = characters.take(currentIndex).toString();
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onNextStep() {
    if (_step < 3) {
      setState(() => _step++);
      _startTypewriter(_stepTexts[_step]!);
    } else {
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _characterController.dispose();
    _pointerPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFullText = _stepTexts[_step]!;
    final bool isTextFinished = _displayedText == currentFullText;

    final createAccountRect = _getWidgetRect(widget.createAccountKey);
    final merchantRect = _getWidgetRect(widget.merchantKey);

    
    final isTopPlacement = _step == 2;

    return Material(
      color: Colors.black.withValues(alpha: 0.65),
      child: Stack(
        children: [
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: OnboardingSkipButton(onSkip: widget.onDismiss),
            ),
          ),

          
          if (_step == 2 && createAccountRect != null)
            OnboardingCreateAccountTarget(
              targetRect: createAccountRect,
              pulseAnimation: _pulseAnimation,
            ),

          
          if (_step == 3 && merchantRect != null)
            OnboardingMerchantTarget(
              targetRect: merchantRect,
              pulseAnimation: _pulseAnimation,
            ),

          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            left: 20,
            right: 20,
            top: isTopPlacement
                ? MediaQuery.of(context).padding.top + 55
                : null,
            bottom: !isTopPlacement
                ? MediaQuery.of(context).size.height * 0.22
                : null,
            child: SlideTransition(
              position: _characterSlideAnimation,
              child: OnboardingBotDialog(
                step: _step,
                displayedText: _displayedText,
                isTextFinished: isTextFinished,
                onNext: _onNextStep,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
