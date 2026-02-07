// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ds_vpn/main.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  final String label;
  bool isLoading;
  final double labelSize, borderRadius;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  Color? backgroundColor, textColr, boderColor;
  CustomButton({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColr,
    this.isLoading = false,
    this.boderColor = Colors.transparent,
    required this.onTap,
    this.labelSize = 16,
    this.borderRadius = 30,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), // Trigger hover effect
      onExit: (_) => setState(() => _isHovered = false), // Reset hover effect
      child: InkWell(
        onTap: widget.isLoading
            ? () {
                print("Disabled");
              }
            : widget.onTap,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: widget.boderColor ?? Colors.transparent),
            color: _isHovered
                ? (widget.backgroundColor ?? colorManager.secondaryColor)
                      .withOpacity(0.8)
                : widget.backgroundColor ?? colorManager.secondaryColor,
          ),
          child: Center(
            child: widget.isLoading
                ? CircularProgressIndicator(color: colorManager.whiteColor)
                : Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.textColr ?? colorManager.bgDark,
                      fontSize: widget.labelSize,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatefulWidget {
  final Widget? child;
  final String label;
  bool isLoading;
  final double labelSize, borderRadius;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  Color? textColr, boderColor;
  OutlineButton({
    super.key,
    required this.label,
    this.textColr,
    this.isLoading = false,
    this.boderColor,
    required this.onTap,
    this.labelSize = 16,
    this.borderRadius = 30,
    this.padding = const EdgeInsets.all(14),
    this.child,
  });

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  bool _isHovered = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: InkWell(
        onTap: widget.isLoading
            ? () {
                print("Disabled");
              }
            : widget.onTap,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.boderColor ?? colorManager.secondaryColor,
            ),
            color: colorManager.bgDark,
          ),
          child: Center(
            child: widget.isLoading
                ? CircularProgressIndicator(color: colorManager.secondaryColor)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 6,
                    children: [
                      if (widget.child != null) widget.child!,
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: widget.textColr ?? colorManager.secondaryColor,
                          fontSize: widget.labelSize,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
