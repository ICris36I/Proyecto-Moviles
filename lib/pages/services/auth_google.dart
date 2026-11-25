import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthGoogle {
  Future<UserCredential?> loginGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    
    //await googleSignIn.initialize();

    try {
      final account = await googleSignIn.authenticate();

      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      print('Error Google Sign-In: $e');
      return null;
    }
  }
}