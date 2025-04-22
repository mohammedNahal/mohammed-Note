import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_note_app/model/note_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/firebase_firestore.dart';
import '../generated/l10n.dart';
import '../provider/note_provider.dart';

class MyNoteScreen extends StatelessWidget {
  const MyNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myNotes), // Translated title
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestoreController().readFavorites(),
        builder: (context, snapshot) {
          // Handling loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          // Handling no data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyNotesState(context);
          }

          // Handling data state
          List<QueryDocumentSnapshot> data = snapshot.data!.docs;
          return _buildNotesGrid(data, context);
        },
      ),
    );
  }

  // Build grid view for notes
  Widget _buildNotesGrid(List<QueryDocumentSnapshot> data, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final cardColor = Colors.primaries[index % Colors.primaries.length].shade100;
        return _buildNoteCard(data[index], cardColor, context);
      },
    );
  }

  // Build individual note card
  Widget _buildNoteCard(QueryDocumentSnapshot noteData, Color cardColor, BuildContext context) {
    return GestureDetector(
      onTap: () => Provider.of<NoteProvider>(context, listen: false).onTapNote(
        context: context,
        snapshot: noteData,
      ),
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNoteTitle(noteData,context: context),
              const SizedBox(height: 8),
              _buildNoteDetails(noteData),
              const Spacer(),
              _buildNoteCreatedAt(noteData),
            ],
          ),
        ),
      ),
    );
  }

  // Build note title with popup menu for options (delete)
  Widget _buildNoteTitle(QueryDocumentSnapshot noteData,{required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${noteData.get('title')}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildPopupMenu(noteData,context: context),
      ],
    );
  }

  // Build popup menu with delete option
  Widget _buildPopupMenu(QueryDocumentSnapshot noteData,{required BuildContext context}) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'delete') {
          await Provider.of<NoteProvider>(context, listen: false).deleteNote(
            context: context,
            noteId: noteData.id,
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Text(S.of(context).delete), // Translated delete text
            ],
          ),
        ),
      ],
      child: const Icon(Icons.more_vert, size: 18),
    );
  }

  // Build note details text
  Widget _buildNoteDetails(QueryDocumentSnapshot noteData) {
    return Text(
      '${noteData.get('details')}',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Build note created date
  Widget _buildNoteCreatedAt(QueryDocumentSnapshot noteData) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        '${noteData.get('createdAt')}',
        style: TextStyle(
          fontSize: 8,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  // Build empty notes state with icon and message
  Widget _buildEmptyNotesState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.edit_calendar_outlined,
            color: Colors.grey,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).emptyNotes, // Translated empty notes message
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
