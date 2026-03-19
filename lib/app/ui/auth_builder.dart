import 'package:flutter/material.dart';
import 'package:flutter_base_app/features/auth/domain/state/auth_bloc.dart';
import 'package:flutter_base_app/features/auth/domain/state/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBuilder extends StatelessWidget {
  const AuthBuilder({
    super.key,
    required this.isNotAuthorized,
    required this.isWaiting,
    required this.isAuthorized,
  });

  final WidgetBuilder isNotAuthorized;
  final WidgetBuilder isWaiting;
  final ValueWidgetBuilder<Object?> isAuthorized;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateAuthorized) {
          return isAuthorized(context, null, null);
        }

        if (state is AuthStateLoading || state is AuthStateSmsSent) {
          return isWaiting(context);
        }

        return isNotAuthorized(context);
      },
      listenWhen: (previous, current) {
        if (current is! AuthStateError) return false;
        if (previous is AuthStateError) {
          return previous.message != current.message;
        }
        return true;
      },
      listener: (context, state) {
        if (state is AuthStateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }
}
