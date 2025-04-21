import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/note_model.dart';

class FirebaseFirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ملاحظات عامة
  Future<bool> create({required Note note}) async {
    try {
      await _firestore.collection('Notes').add(note.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Stream<QuerySnapshot> read() async* {
    yield* _firestore.collection('Notes').snapshots();
  }

  Future<bool> update({required Note note}) async {
    try {
      await _firestore.collection('Notes').doc(note.id).update(note.toMap());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> delete({required String id}) async {
    try {
      await _firestore.collection('Notes').doc(id).delete();
      return true;
    } catch (error) {
      return false;
    }
  }

  //  ملاحظات مفضلة - Favorites

  /// إضافة ملاحظة إلى المفضلة
  Future<bool> addToFavorites({required Note note}) async {
    try {
      await _firestore.collection('Favorites').doc(note.id).set(note.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// قراءة الملاحظات المفضلة
  Stream<QuerySnapshot> readFavorites() async* {
    yield* _firestore.collection('Favorites').snapshots();
  }

  /// حذف ملاحظة من المفضلة
  Future<bool> removeFromFavorites({required String id}) async {
    try {
      await _firestore.collection('Favorites').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// التحقق إذا كانت ملاحظة موجودة في المفضلة
  Future<bool> isFavorite({required String id}) async {
    try {
      final doc = await _firestore.collection('Favorites').doc(id).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// حذف كل الملاحظات من 'Notes'
  Future<bool> deleteAllNotes() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Notes').get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// حذف كل الملاحظات من 'Favorites'
  Future<bool> deleteAllFavorites() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Favorites').get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// حذف الكل من الملاحظات والمفضلة
  Future<bool> deleteAllNotesAndFavorites() async {
    try {
      await deleteAllNotes();
      await deleteAllFavorites();
      return true;
    } catch (e) {
      return false;
    }
  }

}
