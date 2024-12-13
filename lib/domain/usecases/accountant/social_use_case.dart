import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialUseCase {
  Future<GoogleSignInAuthentication?> google() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    if (googleAuth?.accessToken != null) return googleAuth;
    return null;
  }

  Future<FacebookLoginResult> facebook() async {
    return await FacebookLogin().logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
  }
}
