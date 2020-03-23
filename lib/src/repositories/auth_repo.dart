import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  AuthRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount gUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    final AuthCredential cred = GoogleAuthProvider.getCredential(
        idToken: gAuth.idToken, accessToken: gAuth.accessToken);
    return (await _firebaseAuth.signInWithCredential(cred)).user;
  }

  Future<FirebaseUser> signInWithCredentials(String email, String pass) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: pass))
        .user;
  }

  Future<FirebaseUser> signUp(String email, String pass) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: pass))
        .user;
  }

  Future signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    return (await _firebaseAuth.currentUser()) != null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return (await _firebaseAuth.currentUser());
  }
}
