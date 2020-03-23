import 'package:flutter/foundation.dart';

import '../../repositories/auth_repo.dart';

import './bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({@required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  @override
  // TODO: implement initialState
  AuthState get initialState => null;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) yield* _mapAppStartedToState();

    if (event is LoggedIn) yield* _mapLoggedInToState();

    if (event is LoggedOut) yield* _mapLoggedOutToState();
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _authRepository.getCurrentUser();
        yield Authenticate(user);
      }
      yield Deauthenticate();
    } catch (err) {
      yield Deauthenticate();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    yield Authenticate(await _authRepository.getCurrentUser());
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Deauthenticate();
  }
}
