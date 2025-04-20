import 'dart:async';
import 'package:final_project_note_app/Helpers/Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// تعريف نوع listener الخاص بـ Firebase Authentication
typedef FbAuthListener = void Function({required bool status});

class FirebaseAuthController with Helper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// دالة لتسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<bool> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // محاولة تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // إذا كان المستخدم موجودًا والتحقق من البريد الإلكتروني
        if (userCredential.user!.emailVerified) {
          return true;  // النجاح في تسجيل الدخول
        } else {
          // إذا لم يتم التحقق من البريد الإلكتروني، أرسل رسالة تحقق
          await userCredential.user!.sendEmailVerification();
          Navigator.pushReplacementNamed(context, '/login/send_email_verify');
        }
      }
    } on FirebaseAuthException catch (exception) {
      // إذا حدث خطأ في المصادقة، عرض الرسالة للمستخدم
      if (exception.message != null) {
        appSnackBar(context: context, message: exception.message, error: true);
      }
    } catch (error) {
      print(error.toString());
    }
    return false;  // فشل في تسجيل الدخول
  }

  /// دالة لاكتشاف حالة المستخدم وتغيير الواجهة بناءً على الحالة
  StreamSubscription checkUserState({required FbAuthListener listener}) {
    return _auth.authStateChanges().listen(
          (user) => listener(status: user != null),  // إذا كان المستخدم موجودًا
    );
  }

  /// دالة للتسجيل باستخدام البريد الإلكتروني وكلمة المرور
  Future<bool> signup({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // محاولة إنشاء حساب جديد باستخدام البريد الإلكتروني وكلمة المرور
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // إرسال رسالة تحقق عبر البريد الإلكتروني
      await userCredential.user!.sendEmailVerification();
      await signOut();

      // توجيه المستخدم إلى صفحة التحقق من البريد الإلكتروني
      Navigator.pushReplacementNamed(context, '/login/send_email_verify');
    } on FirebaseAuthException catch (exception) {
      // إذا حدث خطأ أثناء التسجيل، عرض رسالة الخطأ
      appSnackBar(context: context, message: exception.code, error: true);
    } catch (error) {
      print(error.toString());
    }
    return false;  // فشل في التسجيل
  }

  /// دالة لإرسال بريد إلكتروني لإعادة تعيين كلمة المرور
  Future<bool> forgetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      // إرسال بريد إلكتروني لإعادة تعيين كلمة المرور
      await _auth.sendPasswordResetEmail(email: email);
      return true;  // نجاح إرسال البريد
    } on FirebaseAuthException catch (exception) {
      // إذا حدث خطأ أثناء إرسال البريد، عرض رسالة الخطأ
      appSnackBar(context: context, message: exception.code, error: true);
    } catch (error) {
      print(error.toString());
    }
    return false;  // فشل في إرسال البريد
  }

  /// دالة لتسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();  // تنفيذ عملية تسجيل الخروج
  }
}
