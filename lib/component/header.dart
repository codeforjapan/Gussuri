import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF002153),
      title: const Text(
            'gussuri',
            style: TextStyle(color: Colors.white),
          ),
      elevation: 0.0,
      automaticallyImplyLeading: false,
    );
  }
}