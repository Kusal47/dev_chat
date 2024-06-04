import 'package:flutter/material.dart';

class CustomOptions extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const CustomOptions({required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: Row(children: [
            icon,
            const SizedBox(width: 10),
            Flexible(
                child: Text('$name',
                    style:
                        const TextStyle(fontSize: 15, color: Colors.black54, letterSpacing: 0.5)))
          ]),
        ));
  }
}
