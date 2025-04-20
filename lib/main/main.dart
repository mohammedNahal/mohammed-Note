import 'package:final_project_note_app/main/note_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// نقطة بداية التطبيق
Future<void> main() async {
  // تأكد من تهيئة الارتباط بين Flutter ومحرك التطبيق (مهم للتعامل مع async و Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase قبل تشغيل التطبيق
  await Firebase.initializeApp();

  // تشغيل تطبيق NoteApp
  runApp(const NoteApp());
}
