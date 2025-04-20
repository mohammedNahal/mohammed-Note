import 'package:flutter/material.dart';
import 'package:final_project_note_app/widgets/app_button.dart';

/// شاشة تُعرض بعد التسجيل، تخبر المستخدم بأنه تم إرسال رابط
/// للتحقق من البريد الإلكتروني وتُتيح له العودة إلى صفحة تسجيل الدخول.
class SendEmailVerificationScreen extends StatelessWidget {
  const SendEmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // محتوى الشاشة يتم وضعه داخل SafeArea لتجنب تداخل الـ notches أو الـ status bar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            // جعل المحتوى في منتصف الشاشة عموديًا وأفقيًا
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // نص مُنسق يوضح للمستخدم الخطوات القادمة
               RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'لقد أرسلنا إلى بريدك الإلكتروني رابط ',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'التحقق من البريد الإلكتروني',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '.\nيرجى التحقق من صندوق الوارد الخاص بك ثم إعادة المحاولة.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // زر للعودة إلى شاشة تسجيل الدخول
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
