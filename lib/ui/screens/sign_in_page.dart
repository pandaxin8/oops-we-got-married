import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '48056550707-qm9ch0h19kc9thkgj1051o1rm0uosld8.apps.googleusercontent.com'  // Add your Web Client ID here
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> _signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); 
    if (googleUser != null) {
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      if (googleAuth != null) {
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await _auth.signInWithCredential(credential);
      } else {
        // Handle authentication failure
      }
    } else {
      // Handle sign-in failure
    } 
  } catch (e) {
    print(e);
    throw FirebaseException(plugin: 'google_sign_in', message: 'Sign-in failed.');
  } finally { 
    // If sign-in is not successful for any reason, throw an error
    throw Exception('Sign-in process failed.'); 
  }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Sign In'),
      backgroundColor: Colors.deepPurple,  // Example of styling improvement
    ),
    body: SingleChildScrollView(  // Useful for avoiding overflow when keyboard appears
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            child: Text('Sign In with Email'),
            onPressed: () {
              // Insert email sign-in logic here
            },
          ),
          SizedBox(height: 20),  // Spacing
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
            child: Text('Sign In with Google'),
            onPressed: () => _signInWithGoogle().then((value) {
              if (value != null) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            }),
          ),
        ],
      ),
    ),
  );
}

}