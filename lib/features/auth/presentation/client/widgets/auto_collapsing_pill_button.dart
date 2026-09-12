

import 'dart:async';
import 'package:flutter/material.dart';

class AutoCollapsingPillButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final Duration collapseDelay;
  final bool initialExpanded;

  const AutoCollapsingPillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.textColor,
    this.backgroundColor,
    required this.onTap,
    this.collapseDelay = const Duration(seconds: 3),
    this.initialExpanded = false,
  });

  @override
  State<AutoCollapsingPillButton> createState() =>
      AutoCollapsingPillButtonState();
}

class AutoCollapsingPillButtonState extends State<AutoCollapsingPillButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  Timer? _collapseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.initialExpanded) {
      expandAndAutoCollapse();
    }
  }

  void expandAndAutoCollapse() {
    _collapseTimer?.cancel();
    _controller.forward();

    _collapseTimer = Timer(widget.collapseDelay, () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  
  void expand() {
    _collapseTimer?.cancel();
    _controller.forward();
  }

  
  void collapse() {
    _collapseTimer?.cancel();
    _controller.reverse();
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          widget.onTap();
          expandAndAutoCollapse();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? widget.textColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.textColor, size: 20),
              SizeTransition(
                sizeFactor: _expandAnimation,
                axis: Axis.horizontal,
                
                axisAlignment: -1.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
