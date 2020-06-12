library google_sign_in_all;

abstract class GoogleSignIn {
  List<String> get scopes;

  Future<AuthCredentials> signIn();
  Future<GoogleAccount> getCurrentUser();
}

abstract class AuthCredentials {
  String get accessToken;
  String get idToken;
}

GoogleSignIn setupGoogleSignIn({
  List<String> scopes,
  String webClientId,
  String webSecret,
}) {
  throw Exception('Unsupported environment');
}

class GoogleAccount {
  GoogleAccount({this.id, this.email, this.displayName, this.photoUrl});
  final String id;
  final String email;
  final String displayName;
  final String photoUrl;
}
