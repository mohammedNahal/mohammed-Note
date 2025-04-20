import 'package:flutter/material.dart';

/// Mixin يحتوي على أدوات مساعدة (Helper methods) قابلة لإعادة الاستخدام
mixin Helper {
  /// دالة لعرض SnackBar في واجهة المستخدم
  ///
  /// [context] هو الـ BuildContext الحالي.
  /// [message] هو النص الذي سيتم عرضه داخل الـ SnackBar.
  /// [error] لتحديد لون الـ SnackBar: أحمر إذا كان خطأ، أخضر إذا كانت العملية ناجحة.
  void appSnackBar({
    required BuildContext context,
    required String? message,
    bool error = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ''),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
