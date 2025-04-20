/// Model class representing a single note in the application.
class Note {
  /// Firestore document ID for this note.
  String id;

  /// Title of the note.
  String title;

  /// Detailed content of the note.
  String details;

  /// Formatted creation timestamp of the note.
  String createdAt;

  /// Default constructor with optional named parameters and sensible defaults.
  Note({
    this.id = '',
    this.title = '',
    this.details = '',
    this.createdAt = '',
  });

  /// Named constructor to create a Note from a Firestore document snapshot.
  ///
  /// [docData] is the map payload of the document.
  /// [documentId] is the Firestore-generated document ID.
  Note.fromMap(Map<String, dynamic> docData, {required String documentId})
      : id = documentId,
        title = docData['title'] as String? ?? '',
        details = docData['details'] as String? ?? '',
        createdAt = docData['createdAt'] as String? ?? '';

  /// Converts this Note instance into a Map suitable for Firestore operations.
  ///
  /// Does not include [id], since Firestore uses the document ID separately.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'details': details,
      'createdAt': createdAt,
    };
  }
}