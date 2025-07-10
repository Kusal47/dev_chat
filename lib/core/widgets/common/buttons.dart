import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final double? radius;
  final Color? labelColor;
  final FontWeight? labelWeight;
  final VoidCallback onPressed;
  final double? fontSize;

  const PrimaryButton({
    super.key,
    required this.label,
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.radius,
    this.labelColor,
    this.labelWeight,
    required this.onPressed,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: backgroundColor ?? primaryColor,
        minimumSize: Size(width ?? double.maxFinite, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: labelColor ?? Theme.of(context).scaffoldBackgroundColor,
          fontSize: fontSize ?? 16,
          fontWeight: labelWeight ?? FontWeight.w600,
        ),
      ),
    );
  }
}

class PrimaryTextButton extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final double? height;
  final VoidCallback onPressed;
  final bool? isSmallButton;

  const PrimaryTextButton({
    super.key,
    required this.label,
    this.height,
    required this.onPressed,
    this.labelColor,
    this.isSmallButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        label,
        style:
            isSmallButton!
                ? Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: labelColor ?? Theme.of(context).primaryColor)
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: labelColor ?? Theme.of(context).primaryColor,
                ),
      ),
    );
  }
}

class PrimaryOutlinedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? borderColor;
  final VoidCallback onPressed;
  final double? radius;
  final Widget? loadingWidget;
  final String title;
  final Color? titleColor;
  final Widget? icon;
  final Color? iconColor;
  final double? iconSize;

  const PrimaryOutlinedButton({
    super.key,
    this.radius,
    this.width,
    this.iconSize,
    this.borderColor,
    this.loadingWidget,
    this.icon,
    this.iconColor,
    this.height,
    this.titleColor,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        elevation: 0,
        minimumSize: Size(width ?? double.infinity, height ?? 40.0),
        side: BorderSide(
          width: 1,
          color: borderColor ?? Theme.of(context).primaryColor,
          style: BorderStyle.solid,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child:
          loadingWidget ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(width: iconSize ?? 15, child: icon),
                ),
              Text(title, style: TextStyle(color: borderColor ?? Theme.of(context).primaryColor)),
            ],
          ),
    );
  }
}

class PrimaryIconButton extends StatelessWidget {
  final Color? labelColor;
  final double? height;
  final VoidCallback onPressed;
  final bool? isSmallButton;
  final IconData? icon;

  const PrimaryIconButton({
    super.key,
    this.height,
    required this.onPressed,
    this.labelColor,
    this.isSmallButton = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        minimumSize: const Size(40, 40),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      child: Icon(icon, color: backgroundColor, size: 30),
    );
  }
}

class TextButtonWidget extends StatelessWidget {
  final Color? labelColor;
  final String? label;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? labelSize;
  const TextButtonWidget({
    super.key,
    this.labelColor,
    required this.label,
    this.backgroundColor,
    this.onTap,
    this.borderColor,
    this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: Border.all(color: borderColor ?? primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Text(
              label ?? '',
              style: TextStyle(color: labelColor ?? Colors.black, fontSize: labelSize ?? 10),
            ),
          ),
        ),
      ),
    );
  }
}
