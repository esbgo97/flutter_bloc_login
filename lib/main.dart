import 'package:bloc_pattern/src/blocs/bloc_delegate.dart';
import 'package:bloc_pattern/src/repositories/auth_repo.dart';
import 'package:bloc_pattern/src/ui/screens/auth/home.dart';
import 'package:bloc_pattern/src/ui/screens/common/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'employee/employeePage.dart';
import 'src/blocs/auth/bloc.dart';
import 'src/ui/screens/auth/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = MyBlocDelegate();
  final AuthRepository authRepository = AuthRepository();
  runApp(BlocProvider(
    create: (context) =>
        AuthBloc(authRepository: authRepository)..add(AppStarted()),
    child: App(
      authRepository: authRepository,
    ),
  ));
}

class App extends StatelessWidget {
  final AuthRepository _authRepository;
  App({Key key, @required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employed App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          print(state);
          if (state is Unitialize) return CircularProgressIndicator();

          if (state is Deauthenticate) return LoginPage();

          if (state is Authenticate) return DashboardPage(user: state.user);

          return Container(
            child: Text("Something is! wrong!"),
          );
        },
      ),
    );
  }
}
