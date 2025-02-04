import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.text,
    this.icon, // Made optional
    this.onTap, // Made optional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0), // More balanced padding
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 16, // Ensure legibility
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: icon != null
            ? Icon(
                icon,
                size: 24, // Consistent icon size
                color: Theme.of(context).iconTheme.color, // Use theme color
              )
            : null, // Avoid rendering an empty space if icon is null
        onTap: onTap ?? () {}, // Prevent null onTap from crashing
      ),
    );
  }
}
