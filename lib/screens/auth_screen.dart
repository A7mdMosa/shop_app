import 'package:flutter/material.dart';

import '/widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  static const String route = '/auth_screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: deviceSize.height,
      width: deviceSize.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/Auth.jpeg'), fit: BoxFit.cover),
      ),
      child: const Center(
        child: AuthCard(),
      ),
    ));
  }
}
