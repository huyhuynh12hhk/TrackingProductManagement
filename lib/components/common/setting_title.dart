
import 'package:flutter/material.dart';

class SettingTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;


  const SettingTitle({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey.shade300
          ),
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
            trailing: Icon(Icons.arrow_right_outlined, size: 32,),
          ),
        ),
      ),
    );
  }
}