import 'package:final_project_note_app/main/note_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Entry point of the application
Future<void> main() async {
  // Ensure the binding between Flutter and the engine is initialized (important for async operations and Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await Firebase.initializeApp();

  // Run the NoteApp application
  runApp(const NoteApp());
}
