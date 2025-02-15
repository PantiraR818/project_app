import 'package:aad_oauth/aad_oauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Google sign-in method
Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      final body = {
        'name': user.displayName.toString(),
        'email': user.email.toString(),
        'img': user.photoURL.toString(),
      };

      print("API Body: $body");

      // await callApi(body);
    }

    return userCredential;
  } catch (e) {
    print('exception->$e');
    return null;
  }
}

void logout(AadOAuth oauth) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  oauth.logout();
}

Future<bool> signOutFromGoogle() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await GoogleSignIn().disconnect();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    return true;
  } catch (e) {
    print('Logout exception: $e');
    return false;
  }
}
