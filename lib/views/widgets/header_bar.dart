import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/Casa.png', height: 50),
          Image.asset('assets/images/obix.png', height: 50),
          Image.asset('assets/images/notificacion.png', height: 50),
        ],
      ),
    );
  }
}
