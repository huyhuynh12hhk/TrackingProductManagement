import 'package:flutter/material.dart';

class DividerTitle extends StatelessWidget {
  final Widget content;
  const DividerTitle({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        content,
        // Text(
        //   style: TextStyle(color: Colors.grey[700], fontSize: 18),
        // ),
        const SizedBox(
          width: 10,
        ),
        const Expanded(child: Divider())
      ],
    );
  }
}
