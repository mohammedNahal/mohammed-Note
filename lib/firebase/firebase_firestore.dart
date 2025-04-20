import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_note_app/model/note_model.dart';

class FirebaseFirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// دالة لإنشاء ملاحظة جديدة في قاعدة البيانات
  Future<bool> create({required Note note}) async {
    try {
      // إضافة الملاحظة إلى مجموعة 'Notes'
      await _firestore.collection('Notes').add(note.toMap());
      return true;  // نجاح في إضافة الملاحظة
    } catch (error) {
      return false;  // فشل في إضافة الملاحظة
    }
  }

  /// دالة لقراءة الملاحظات من قاعدة البيانات باستخدام Stream
  Stream<QuerySnapshot> read() async* {
    // إرجاع الملاحظات بشكل مستمر باستخدام snapshots
    yield* _firestore.collection('Notes').snapshots();
  }

  /// دالة لتحديث ملاحظة موجودة في قاعدة البيانات
  Future<bool> update({required Note note}) async {
    try {
      // تحديث الملاحظة في مجموعة 'Notes' باستخدام id الملاحظة
      await _firestore.collection('Notes').doc(note.id).update(note.toMap());
      return true;  // نجاح في تحديث الملاحظة
    } catch (error) {
      return false;  // فشل في تحديث الملاحظة
    }
  }

  /// دالة لحذف ملاحظة من قاعدة البيانات باستخدام id
  Future<bool> delete({required String id}) async {
    try {
      // حذف الملاحظة من مجموعة 'Notes' باستخدام id الملاحظة
      await _firestore.collection('Notes').doc(id).delete();
      return true;  // نجاح في حذف الملاحظة
    } catch (error) {
      return false;  // فشل في حذف الملاحظة
    }
  }
}
