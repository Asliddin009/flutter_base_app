import 'package:flutter/material.dart';
import 'package:flutter_base_app/app/ui/app_loader.dart';
import 'package:flutter_base_app/app/ui/auth_builder.dart';
import 'package:flutter_base_app/app/ui/home_screen.dart';
import 'package:flutter_base_app/features/auth/ui/auth_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBuilder(
      isNotAuthorized: (context) => AuthScreen(),
      isWaiting: (context) => const AppLoader(),
      isAuthorized: (context, value, child) => HomeScreen(userEntity: value),
    );
  }
}
