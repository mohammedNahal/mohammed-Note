import 'package:flutter/material.dart';
import 'package:final_project_note_app/widgets/app_button.dart';

/// شاشة تعرض بعد نجاح إرسال رابط إعادة تعيين كلمة المرور.
/// تخبر المستخدم بالتحقق من بريده الإلكتروني وتوفر زر العودة لتسجيل الدخول.
class SendPasswordSuccessScreen extends StatelessWidget {
  const SendPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدم SafeArea لتجنب التداخل مع الحواف والـ status bar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            // محاذاة المحتوى في وسط الشاشة
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // رسالة منسقة للمستخدم
               RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'لقد أرسلنا إلى بريدك الإلكتروني رابط ',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'إعادة تعيين كلمة المرور',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '.\nيرجى التحقق من بريدك وإعادة المحاولة.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // زر للعودة إلى صفحة تسجيل الدخول
              AppButton(
                borderRadius: 7,
                backgroundColor: Colors.teal.shade500,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('العودة إلى تسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
