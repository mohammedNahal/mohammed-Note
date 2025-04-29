import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/utils/Helpers/helpers.dart';
import '../../data/datasources/remote/firebase_firestore.dart';

import '../../data/models/note_model.dart';
import '../screens/create_update_note_screen.dart';
import '../search/search_delegate.dart';

/// Provider responsible for managing note-related operations
class NoteProvider extends ChangeNotifier with Helper {
  /// Build a Note model based on the TextEditingController values.
  Note buildNote({
    String? existingId,
    required TextEditingController titleController,
    required TextEditingController detailsController,
    required String formattedDate,
  }) {
    return Note(
      id: existingId ?? '',
      title: titleController.text,
      details: detailsController.text,
      createdAt: formattedDate,
    );
  }

  /// Save the note: create if [noteId] is null, or update if it exists.
  Future<void> saveNote({
    String? noteId,
    required BuildContext context,
    required TextEditingController titleController,
    required TextEditingController detailsController,
    required String formattedDate,
  }) async {
    try {
      final note = buildNote(
        existingId: noteId,
        titleController: titleController,
        detailsController: detailsController,
        formattedDate: formattedDate,
      );
      final success =
      noteId == null
          ? await FirebaseFirestoreController().create(note: note)
          : await FirebaseFirestoreController().update(note: note);

      appSnackBar(
        context: context,
        message:
        noteId == null
            ? 'Note added successfully.'
            : 'Note updated successfully.',
        error: !success,
      );
    } catch (e) {
      appSnackBar(
        context: context,
        message: 'An error occurred: $e',
        error: true,
      );
    }
  }

  /// Converts Firestore snapshot into a Note object.
  Note noteFromSnapshot(QueryDocumentSnapshot snapshot) {
    return Note.fromFirestrore(
      snapshot.data() as Map<String, dynamic>,
      documentId: snapshot.id,
    );
  }

  /// Navigate to the edit screen when a note card is tapped.
  void onTapNote({
    required BuildContext context,
    required QueryDocumentSnapshot snapshot,
  }) {
    final note = noteFromSnapshot(snapshot);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateUpdateNoteScreen(title: 'Update', note: note),
      ),
    );
  }

  /// Start the note search process.
  void searchNotes({required BuildContext context}) async {
    final querySnapshot = await FirebaseFirestoreController().read().first;
    final notes =
    querySnapshot.docs.map((doc) => noteFromSnapshot(doc)).toList();

    showSearch(context: context, delegate: NoteSearchDelegate(notes: notes));
  }

  /// Delete a specific note from the collection.
  Future<void> deleteNote({
    required BuildContext context,
    required String noteId,
  }) async {
    final success = await FirebaseFirestoreController().delete(id: noteId);

    appSnackBar(
      context: context,
      message: success ? 'Note deleted.' : 'Delete failed.',
      error: !success,
    );

    notifyListeners();
  }

  /// Update favorite status: add the note to favorites if not already, or remove if it is.
  Future<void> updateFavoriteStatus({
    required BuildContext context,
    required Note note,
  }) async {
    try {
      final isFav = await FirebaseFirestoreController().isFavorite(id: note.id);
      bool success;
      if (isFav) {
        // Remove the note from favorites
        success = await FirebaseFirestoreController().removeFromFavorites(
          id: note.id,
        );
        appSnackBar(
          context: context,
          message:
          success
              ? 'Removed from favorites.'
              : 'Failed to remove from favorites.',
          error: !success,
        );
      } else {
        // Add the note to favorites
        success = await FirebaseFirestoreController().addToFavorites(
          note: note,
        );
        appSnackBar(
          context: context,
          message:
          success ? 'Added to favorites.' : 'Failed to add to favorites.',
          error: !success,
        );
      }
      notifyListeners();
    } catch (e) {
      appSnackBar(
        context: context,
        message: 'Error updating favorite status: $e',
        error: true,
      );
    }
  }

  /// Delete a favorite note separately.
  Future<void> deleteFavoriteNote({
    required BuildContext context,
    required String noteId,
  }) async {
    final success = await FirebaseFirestoreController().removeFromFavorites(
      id: noteId,
    );

    appSnackBar(
      context: context,
      message:
      success
          ? 'Favorite note deleted.'
          : 'Failed to delete favorite note.',
      error: !success,
    );
    notifyListeners();
  }

  /// Delete all favorite notes.
  Future<void> deleteAllFavorites({required BuildContext context}) async {
    final success = await FirebaseFirestoreController().deleteAllFavorites();

    appSnackBar(
      context: context,
      message:
      success
          ? 'All favorites deleted.'
          : 'Failed to delete all favorites.',
      error: !success,
    );
    notifyListeners();
  }

  /// Delete all notes (non-favorite).
  Future<void> deleteAllNotes({required BuildContext context}) async {
    final success = await FirebaseFirestoreController().deleteAllNotes();

    appSnackBar(
      context: context,
      message: success ? 'All notes deleted.' : 'Failed to delete notes.',
      error: !success,
    );
    notifyListeners();
  }

  /// Delete all notes and favorites together.
  Future<void> deleteAllNotesAndFavorites({
    required BuildContext context,
  }) async {
    final success =
    await FirebaseFirestoreController().deleteAllNotesAndFavorites();

    appSnackBar(
      context: context,
      message: success ? 'All notes deleted.' : 'Failed to delete all notes .',
      error: !success,
    );
    notifyListeners();
  }

  /// Refresh the UI (useful with a RefreshIndicator).
  Future<void> onRefresh() async {
    notifyListeners();
  }

  /// Get the appropriate favorite icon based on the current status.
  Future<Icon> getFavoriteIcon({required String noteId}) async {
    final isFav = await FirebaseFirestoreController().isFavorite(id: noteId);
    return Icon(isFav ? Icons.bookmark_outlined : Icons.bookmark_border);
  }

  /// Create a new favorite note with the given parameters.
  Note favoriteNote({
    required String id,
    required String title,
    required String details,
    required String createdAt,
  }) {
    Note note = Note();
    note.id = id;
    note.title = title;
    note.details = details;
    note.createdAt = createdAt;
    return note;
  }
}
