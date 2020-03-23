import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Unitialize extends AuthState {
  @override
  String toString() =>"no inicializado!";
  
}

class Authenticate extends AuthState{
  final FirebaseUser user;
  const Authenticate(this.user);

  @override
  List<Object> get props => [user];
  String toString() =>"autenticado!";
}

class Deauthenticate extends AuthState{
  @override
  String toString() =>"deautenticado!";
}