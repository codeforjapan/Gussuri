import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String? pageTitle;
  const Header({super.key, this.pageTitle});

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF002153),
      title: Text(
        pageTitle ?? 'gussuri',
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
    );
  }
}
