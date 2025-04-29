import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/note_model.dart';


class FirebaseFirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new note and store it in the 'Notes' collection
  Future<bool> create({required Note note}) async {
    try {
      await _firestore.collection('Notes').add(note.toFirestore());
      return true;
    } catch (error) {
      return false;
    }
  }

  /// Listen to real-time updates from the 'Notes' collection
  Stream<QuerySnapshot> read() async* {
    yield* _firestore.collection('Notes').snapshots();
  }

  /// Update an existing note by its ID in the 'Notes' collection
  Future<bool> update({required Note note}) async {
    try {
      await _firestore.collection('Notes').doc(note.id).update(note.toFirestore());
      return true;
    } catch (error) {
      return false;
    }
  }

  /// Delete a note from the 'Notes' collection using its ID
  Future<bool> delete({required String id}) async {
    try {
      await _firestore.collection('Notes').doc(id).delete();
      return true;
    } catch (error) {
      return false;
    }
  }

  // Favorite Notes

  /// Add a note to the 'Favorites' collection
  Future<bool> addToFavorites({required Note note}) async {
    try {
      await _firestore.collection('Favorites').doc(note.id).set(note.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Listen to real-time updates from the 'Favorites' collection
  Stream<QuerySnapshot> readFavorites() async* {
    yield* _firestore.collection('Favorites').snapshots();
  }

  /// Remove a note from the 'Favorites' collection using its ID
  Future<bool> removeFromFavorites({required String id}) async {
    try {
      await _firestore.collection('Favorites').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if a specific note exists in the 'Favorites' collection
  Future<bool> isFavorite({required String id}) async {
    try {
      final doc = await _firestore.collection('Favorites').doc(id).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Delete all documents from the 'Notes' collection
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

  /// Delete all documents from the 'Favorites' collection
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

  /// Delete all notes from both 'Notes' and 'Favorites' collections
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
