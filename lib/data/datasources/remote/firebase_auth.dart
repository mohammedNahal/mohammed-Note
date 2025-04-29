import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/utils/Helpers/helpers.dart';

// Definition of the Firebase Authentication listener type
typedef FbAuthListener = void Function({required bool status});

class FirebaseAuthController with Helper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Function to sign in using email and password
  Future<bool> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to sign in using email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // If the user exists and the email is verified
        if (userCredential.user!.emailVerified) {
          return true; // Login successful
        } else {
          // If email is not verified, send a verification email
          await userCredential.user!.sendEmailVerification();
          Navigator.pushReplacementNamed(context, '/login/send_email_verify');
        }
      }
    } on FirebaseAuthException catch (exception) {
      // If an authentication error occurs, show the message to the user
      if (exception.message != null) {
        appSnackBar(context: context, message: exception.message, error: true);
      }
    } catch (error) {
      print(error.toString());
    }
    return false; // Login failed
  }

  /// Function to monitor user state and change UI accordingly
  StreamSubscription checkUserState({required FbAuthListener listener}) {
    return _auth.authStateChanges().listen(
          (user) => listener(status: user != null), // If user is logged in
    );
  }

  /// Function to sign in using Google account
  Future<bool> signWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        appSnackBar(context: context, message: "Canceled.", error: true);
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (error) {
      appSnackBar(context: context, message: error.message ?? 'Error happen.', error: true);
      return false;
    } catch (error) {
      print("Google Sign-In Error: $error");
      appSnackBar(
        context: context,
        message: 'Error in Sign in with google.',
        error: true,
      );
      return false;
    }
  }

  /// Function to sign up using email and password
  Future<bool> signup({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to create a new account using email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification
      await userCredential.user!.sendEmailVerification();
      await signOut();

      // Redirect the user to the email verification page
      Navigator.pushReplacementNamed(context, '/login/send_email_verify');
    } on FirebaseAuthException catch (exception) {
      // If an error occurs during sign-up, show the error message
      appSnackBar(context: context, message: exception.code, error: true);
    } catch (error) {
      print(error.toString());
    }
    return false; // Sign-up failed
  }

  /// Function to send a password reset email
  Future<bool> forgetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email);
      return true; // Email sent successfully
    } on FirebaseAuthException catch (exception) {
      // If an error occurs while sending the email, show the error message
      appSnackBar(context: context, message: exception.code, error: true);
    } catch (error) {
      print(error.toString());
    }
    return false; // Failed to send email
  }

  /// Function to sign out
  Future<void> signOut() async {
    await _auth.signOut(); // Execute sign-out
  }
}
