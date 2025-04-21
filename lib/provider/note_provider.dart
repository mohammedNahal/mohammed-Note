import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Helpers/Helper.dart';
import '../firebase/firebase_firestore.dart';
import '../model/note_model.dart';
import '../screens/create_update_note_screen.dart';
import '../search/search_delegate.dart';

/// Provider المسؤول عن إدارة العمليات المتعلقة بالملاحظات
class NoteProvider extends ChangeNotifier with Helper {
  /// بناء نموذج الملاحظة بناءً على قيم الـ TextEditingController
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

  /// حفظ الملاحظة: إنشاء إذا كان [noteId] فارغ أو تحديث إذا كان موجوداً
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

  /// تحويل مستند Firestore إلى كائن Note
  Note noteFromSnapshot(QueryDocumentSnapshot snapshot) {
    return Note.fromMap(
      snapshot.data() as Map<String, dynamic>,
      documentId: snapshot.id,
    );
  }

  /// عند النقر على بطاقة الملاحظة: الانتقال لشاشة التعديل
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

  /// بدء عملية البحث عن الملاحظات
  void searchNotes({required BuildContext context}) async {
    final querySnapshot = await FirebaseFirestoreController().read().first;
    final notes =
        querySnapshot.docs.map((doc) => noteFromSnapshot(doc)).toList();

    showSearch(context: context, delegate: NoteSearchDelegate(notes: notes));
  }

  /// حذف ملاحظة محددة من مجموعة الملاحظات
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

  /// دالة لتحديث حالة المفضلة: تضيف الملاحظة للمفضلة إذا لم تكن موجودة، أو تحذفها إذا كانت موجودة
  Future<void> updateFavoriteStatus({
    required BuildContext context,
    required Note note,
  }) async {
    try {
      final isFav = await FirebaseFirestoreController().isFavorite(id: note.id);
      bool success;
      if (isFav) {
        // إزالة الملاحظة من المفضلة
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
        // إضافة الملاحظة إلى المفضلة
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

  /// حذف ملاحظة من المفضلة بشكل منفصل
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

  /// حذف جميع الملاحظات المفضلة
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

  /// حذف جميع الملاحظات (غير المفضلة)
  Future<void> deleteAllNotes({required BuildContext context}) async {
    final success = await FirebaseFirestoreController().deleteAllNotes();

    appSnackBar(
      context: context,
      message: success ? 'All notes deleted.' : 'Failed to delete notes.',
      error: !success,
    );
    notifyListeners();
  }

  /// حذف جميع الملاحظات والمفضلة معاً
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

  /// دالة لإعادة تحميل الواجهة (يمكن استخدامها مع RefreshIndicator)
  Future<void> onRefresh() async {
    notifyListeners();
  }

  /// ترجع أيقونة المفضلة المناسبة حسب الحالة (مملوءة إذا كانت مفضلة، فارغة إذا لا)
  Future<Icon> getFavoriteIcon({required String noteId}) async {
    final isFav = await FirebaseFirestoreController().isFavorite(id: noteId);
    return Icon(isFav ? Icons.bookmark_outlined : Icons.bookmark_border);
  }

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
