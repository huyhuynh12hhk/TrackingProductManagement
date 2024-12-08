
import 'package:flutter/material.dart';

class PostSettingMenu extends StatefulWidget {
  final void Function()? onPressed;
  const PostSettingMenu({super.key, required this.onPressed});

  @override
  State<PostSettingMenu> createState() => _PostSettingMenuState();
}

class _PostSettingMenuState extends State<PostSettingMenu> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed,
      icon: Icon(Icons.more_horiz),
    );
  }
}