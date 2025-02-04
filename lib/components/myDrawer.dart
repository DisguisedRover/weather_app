import 'package:flutter/material.dart';
import 'drawerTile.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 68, 195, 230),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset('lib/images/1.png', height: 100),
                  )
                ],
              )),
          MyDrawerTile(
            text: 'Home',
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context); // Close drawer when Home is clicked
            },
          ),
          MyDrawerTile(
            text: 'Settings',
            icon: Icons.settings,
            onTap: () {
              Navigator.pushNamed(context, '/settings'); // Example navigation
            },
          ),
          MyDrawerTile(
            text: 'About',
            icon: Icons.info,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text('Weather App v1.0'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
