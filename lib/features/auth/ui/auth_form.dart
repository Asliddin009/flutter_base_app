import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/features/auth/domain/state/auth_bloc.dart';
import 'package:flutter_base_app/features/auth/domain/state/auth_event.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(hintText: 'Phone'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(
              AuthEventSignInSms(phone: _phoneController.text),
            );
          },
          child: const Text('Send phone'),
        ),
      ],
    );
  }
}
