import 'package:dev_chat/core/widgets/common/text_form_field.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget(
      {super.key,
      this.onTap,
      this.title,
      this.onChanged,
      required this.onSaved,
      this.icon,
      this.readOnly = false,
      this.onClearTap, this.controller});
  final Function()? onTap;
  final Function()? onClearTap;
  final String? title;
  final Function(String)? onChanged;
  final Function(String) onSaved;
  final IconData? icon;
  final bool readOnly;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PrimaryFormField(
        controller: controller,
        suffixIcon: GestureDetector(onTap: onClearTap, child: Icon(icon)),
        readOnly: readOnly,
        hintTxt: title,
        onTap: onTap ?? null,
        onSaved: onSaved,
        onChanged: onChanged,
        hintIcon: Icon(Icons.search),
      ),
    );
  }
}
