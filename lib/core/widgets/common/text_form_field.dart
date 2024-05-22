import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/colors.dart';
import '../../resources/ui_assets.dart';
class PrimaryTextField extends StatelessWidget {
  final Function(String)? onValueChange;
  final String hint;
  final String? prefixIconPath;
  final Widget? prefixIcon;
  final String? suffixIconPath;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final Color? border;
  final bool? readOnly;
  final bool? showError;
  final bool? autofocus;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final TextCapitalization textCapitalization;
  final Color? fillColor;
  final bool showLable;
  final bool obscureText;
  final FocusNode? focusNode;
  final double borderRadius;

  final int? maxLength;
  final int? maxLine;
  final bool? isEnabled;
  final List<TextInputFormatter>? inputFormatters;

  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;

  const PrimaryTextField({
    Key? key,
    required this.hint,
    this.prefixIconPath,
    this.suffixIconPath,
    this.onValueChange,
    this.controller,
    this.validator,
    required this.textInputAction,
    required this.textInputType,
    this.border,
    this.readOnly = false,
    this.showError = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.onTap,
    this.onSubmitted,
    this.autofocus = false,
    this.showLable = false,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnabled = false,
    this.focusNode,
    this.borderRadius = 10,
    this.maxLength,
    this.maxLine,
    this.inputFormatters,
    this.focusedBorder,
    this.enabledBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: maxLine,
      enabled: isEnabled,
      focusNode: focusNode,
      obscureText: obscureText,
      autofocus: autofocus!,
      textCapitalization: textCapitalization,
      onFieldSubmitted: onSubmitted,
      onTap: (onTap != null) ? onTap! : null,
      readOnly: (readOnly == null) ? false : readOnly!,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      // maxLines: 1,
      validator: (validator != null) ? validator : null,
      controller: (controller != null) ? controller : null,
      onChanged: (text) {
        if (onValueChange != null) {
          onValueChange!(text);
        }
      },
      decoration: InputDecoration(
        label: showLable
            ? Text(
                hint,
                style: const TextStyle(color: dimGreyColor),
              )
            : null,
        fillColor: fillColor ?? Colors.transparent,
        filled: true,
        prefixIcon: (prefixIconPath != null)
            ? SvgPicture.asset(
                prefixIconPath!,
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
              )
            : prefixIcon,
        suffixIcon: (suffixIconPath != null)
            ? SvgPicture.asset(suffixIconPath!, fit: BoxFit.scaleDown)
            : suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(width: 1, color: (border == null) ? dividerColor : border!),
            ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(width: 1, color: (border == null) ? primaryColor : border!),
        ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(width: 1, color: (border == null) ? primaryColor : border!),
            ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: const BorderSide(width: 1, color: primaryColorDark),
        ),
        errorStyle: (showError!) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 0),
        hintText: hint,
        hintStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }
}

// class PasswordField extends StatelessWidget {
//   final FocusNode? focusNode;
//   final String hint;
//   final bool showPassword;
//   final VoidCallback onEyeClick;
//   final Function(String)? onSubmit;
//   final Function(String)? onValueChange;
//   // final TextEditingController controller;
//   final TextInputAction textInputAction;
//   final String? Function(String? value) validator;
//   const PasswordField({
//     Key? key,
//     required this.hint,
//     required this.showPassword,
//     required this.onEyeClick,
//     // required this.controller,
//     required this.textInputAction,
//     required this.onValueChange,
//     this.onSubmit,
//     this.focusNode,
//     required this.validator,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PrimaryTextField(
//       maxLine: 1,
//       onSubmitted: onSubmit,
//       focusNode: focusNode,
//       // controller: controller,
//       obscureText: !showPassword,
//       hint: hint,
//       validator: validator,
//       textInputAction: textInputAction,
//       onValueChange: onValueChange,
//       textInputType: TextInputType.visiblePassword,
//       suffixIcon: InkWell(
//         onTap: onEyeClick,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
//           // child: SvgPicture.asset(
//           //   IconPath.eyeOff,
//           //   fit: BoxFit.scaleDown,
//           //   colorFilter: ColorFilter.mode(
//           //     !showPassword ? primaryColor : dividerColor,
//           //     BlendMode.srcIn,
//           //   ),
//           // ),
//           child: SvgPicture.asset(
//             showPassword ? UIAssets.eyeOn : UIAssets.eyeOff,
//             fit: BoxFit.scaleDown,
//             height: 12,
//             width: 12,
//             colorFilter: ColorFilter.mode(
//               !showPassword ? primaryColor : hintColor,
//               BlendMode.srcIn,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class CustomDropdownFormField<T> extends StatelessWidget {
  final List<T>? items;
  final T? value;
  void Function(T?)? onChanged;
  final String Function(T)? displayText;
  final String? hintText;
  final InputDecoration? decoration;
  final UnderlineInputBorder? border;
  final String? hint;

  CustomDropdownFormField({
    super.key,
    this.items,
    this.value,
    this.onChanged,
    this.displayText,
    this.hintText,
    this.decoration,
    this.border,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items?.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayText != null ? displayText!(item) : item.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Select an item" : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: decoration ??
          InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 12), //TODO: VERTICAL:10
            border: border ??
                const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: dividerColor,
                    )),
            errorBorder: border ??
                const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: dividerColor,
                    )),
            enabledBorder: border ??
                const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: dividerColor,
                    )),
            focusedBorder: border ??
                const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: dividerColor,
                    )),
            disabledBorder: border ??
                const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: dividerColor,
                    )),
          ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }
}

// class PrimaryFormField extends HookWidget {
//   // final String? label;
//   final String? hintTxt;
//   final Widget? hintIcon;
//   final bool? isFilled;
//   // final bool isRequired;

//   final String? Function(String?)? validator;
//   final void Function(String)? onChanged;
//   final void Function(String) onSaved;
//   final Widget? prefixIcon;
//   // final double? labelHeight;
//   final bool? isPassword;
//   final TextInputType? keyboardType;
//   final TextEditingController? controller;

//   final int maxLines;
//   final int? minLines;
//   final bool? autofocus;
//   final Widget? suffixIcon;
//   final String? initialValue;
//   final bool? readOnly;
//   final InputBorder? focusedBorder;
//   final InputBorder? enabledBorder;
//   final EdgeInsetsGeometry? contentPadding;
//   final List<TextInputFormatter>? inputFormatters;
//   final double? fontSize;

//   final void Function()? onTap;
//   // final TextEditingController? controller;
//   const PrimaryFormField({
//     Key? key,
//     this.onTap,
//     this.hintTxt,
//     this.initialValue,
//     this.hintIcon,
//     this.controller,
//     // this.label,

//     // this.isRequired = false,
//     this.validator,
//     this.onChanged,
//     this.maxLines = 1,
//     this.minLines,
//     required this.onSaved,
//     this.suffixIcon,
//     this.prefixIcon,
//     // this.labelHeight,
//     this.isPassword = false,
//     this.isFilled = false,
//     this.keyboardType,
//     this.readOnly,
//     this.focusedBorder,
//     this.enabledBorder,
//     // this.controller,
//     this.contentPadding,
//     this.autofocus,
//     this.inputFormatters,
//     this.fontSize,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isPasswordVisible = useState(isPassword!);
//     return TextFormField(
//       onTap: onTap,
//       minLines: minLines ?? 1,
//       maxLines: maxLines,
//       initialValue: initialValue,
//       keyboardType: keyboardType,
//       controller: controller,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: validator,
//       onSaved: (value) {
//         onSaved(value!);
//       },
//       readOnly: readOnly ?? false,
//       inputFormatters: inputFormatters,

//       onChanged: onChanged,
//       autofocus: autofocus ?? false,
//       obscureText: isPasswordVisible.value,
//       // controller: controller,
//       decoration: InputDecoration(
//         // prefix: prefixIcon,

//         errorMaxLines: 2,
//         prefixIcon: hintIcon,

//         suffixIcon: isPassword!
//             ? InkWell(
//                 onTap: () {
//                   isPasswordVisible.value = !isPasswordVisible.value;
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0),
//                   child: Icon(isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
//                       size: 25, color: Theme.of(context).primaryColor),
//                 ))
//             : suffixIcon,
//         hintText: hintTxt,
//         hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: Colors.grey,
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//         labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: kGrey200,
//               fontSize: 18,
//             ),
//         filled: isFilled!,
//         isDense: true,
//         contentPadding: contentPadding ??
//             const EdgeInsets.symmetric(horizontal: 10, vertical: 15), //TODO: VERTICAL:12
//         fillColor: Colors.white70,
//         errorBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(
//               width: 1,
//               color: dividerColor,
//             )),
//         focusedErrorBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(
//               width: 1,
//               color: dividerColor,
//             )),
//         enabledBorder: enabledBorder ??
//             const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 borderSide: BorderSide(
//                   width: 1,
//                   color: dividerColor,
//                 )),
//         focusedBorder: focusedBorder ??
//             const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 borderSide: BorderSide(
//                   width: 1,
//                   color: dividerColor,
//                 )),
//       ),
//       style: TextStyle(
//         color: Colors.black,
//         fontSize: fontSize ?? 14,
//       ),
//     );
//   }
// }
