import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Helpers/Helper.dart';
import '../firebase/firebase_firestore.dart';
import '../model/note_model.dart';
import '../screens/create_update_note_screen.dart';
import '../search/search_delegate.dart';

/// Provider responsible for handling note-related operations
class NoteProvider extends ChangeNotifier with Helper {
  /// Controller for the note's title field in the create/update screen
  late final TextEditingController _titleController;


  /// Controller for the note's details field in the create/update screen
  late final TextEditingController _detailsController;

  /// Formatted timestamp when creating/updating a note
  late String _formattedDate;

  bool _isTitleControllerInitialized = false;
  bool _isDetailsControllerInitialized = false;

  /// Getter for the title TextEditingController
  TextEditingController get titleController {
    if (!_isTitleControllerInitialized) {
      _titleController = TextEditingController();
      _isTitleControllerInitialized = true;
    }
    return _titleController;
  }

  /// Getter for the details TextEditingController
  TextEditingController get detailsController {
    if(!_isDetailsControllerInitialized){
      _detailsController = TextEditingController();
      _isDetailsControllerInitialized = true;
    }
    return _detailsController;
  }

  /// Getter for the formatted date string
  String get formattedDate => _formattedDate;

  /// Initializes controllers and formatted date when opening the create/edit screen
  ///
  /// [initialTitle] and [initialDetails] prefill the fields when editing
  void initCreateUpdate({String initialTitle = '', String initialDetails = ''}) {
    // لا حاجة للتحقق من null حيث أن المتغيرات سيتم تهيئتها دوماً
    if (!_isTitleControllerInitialized) {
      _titleController = TextEditingController(text: initialTitle);
      _isTitleControllerInitialized = true;
    }
    if (!_isDetailsControllerInitialized) {
      _detailsController = TextEditingController(text: initialDetails);
      _isDetailsControllerInitialized = true;
    }
    // تعيين التاريخ بتنسيق مخصص
    _formattedDate = DateFormat('EEEE, MMM d, yyyy • hh:mm a')
        .format(DateTime.now());
  }

  /// Disposes the create/update controllers when leaving the screen
  void disposeCreateUpdate() {
    if (_isTitleControllerInitialized) {
      _titleController.dispose();
      _isTitleControllerInitialized = false;
    }
    if (_isDetailsControllerInitialized) {
      _detailsController.dispose();
      _isDetailsControllerInitialized = false;
    }
  }

  /// Builds a new Note object from the current controller values
  Note buildNote({String? existingId}) {
    return Note(
      id: existingId ?? '',
      title: _titleController.text,
      details: _detailsController.text,
      createdAt: _formattedDate,
    );
  }

  /// Saves a note: creates if [noteId] is null, otherwise updates
  ///
  /// Shows a SnackBar on success or error and navigates back to '/home'.
  Future<void> saveNote({
    String? noteId,
    required BuildContext context,
  }) async {
    try {
      final note = buildNote(existingId: noteId);
      final success = noteId == null
          ? await FirebaseFirestoreController().create(note: note)
          : await FirebaseFirestoreController().update(note: note);

      appSnackBar(
        context: context,
        message: noteId == null
            ? 'Note added successfully.'
            : 'Note updated successfully.',
        error: !success,
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      appSnackBar(
        context: context,
        message: 'An error occurred: \$e',
        error: true,
      );
    }
  }

  /// Converts a Firestore document snapshot into a Note model
  ///
  /// [snapshot] is the Firestore document to parse
  Note noteFromSnapshot(QueryDocumentSnapshot snapshot) {
    return Note.fromMap(
      snapshot.data() as Map<String, dynamic>,
      documentId: snapshot.id,
    );
  }

  /// Handles tapping on a note card: navigates to the edit screen
  void onTapNote({
    required BuildContext context,
    required QueryDocumentSnapshot snapshot,
  }) {
    final note = noteFromSnapshot(snapshot);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateUpdateNoteScreen(
          title: 'Update',
          note: note,
        ),
      ),
    );
  }

  /// Initiates search flow by fetching notes and opening search delegate
  void searchNotes({required BuildContext context}) async {
    final querySnapshot = await FirebaseFirestoreController().read().first;
    final notes = querySnapshot.docs
        .map((doc) => noteFromSnapshot(doc))
        .toList();

    showSearch(
      context: context,
      delegate: NoteSearchDelegate(notes: notes),
    );
  }

  /// Deletes a note by [noteId] and shows a confirmation SnackBar
  Future<void> deleteNote({
    required BuildContext context,
    required String noteId,
  }) async {
    final success =
    await FirebaseFirestoreController().delete(id: noteId);

    appSnackBar(
      context: context,
      message: success ? 'Note deleted.' : 'Delete failed.',
      error: !success,
    );

    // Refresh UI
    notifyListeners();
  }
}
