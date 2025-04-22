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

  /// Creates a Note instance from a Firestore document map.
  ///
  /// [docData] contains the note data retrieved from Firestore.
  /// [documentId] is the unique Firestore document ID.
  Note.fromMap(Map<String, dynamic> docData, {required String documentId})
      : id = documentId,
        title = docData['title'] as String? ?? '',
        details = docData['details'] as String? ?? '',
        createdAt = docData['createdAt'] as String? ?? '';

  /// Converts the Note instance into a map to be stored in Firestore.
  ///
  /// Note: [id] is not included because Firestore handles it separately.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'details': details,
      'createdAt': createdAt,
    };
  }
}
