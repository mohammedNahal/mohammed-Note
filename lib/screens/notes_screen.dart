import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_note_app/firebase/firebase_firestore.dart';
import 'package:final_project_note_app/provider/user_provider.dart';
import 'package:final_project_note_app/screens/create_update_note_screen.dart';
import 'package:final_project_note_app/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../model/note_model.dart';
import '../provider/note_provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildNotesStream(context),
    );
  }

  // Builds the AppBar with title and search icon
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(S
          .of(context)
          .notes), // Translated text
      actions: [
        IconButton(
          onPressed: () => _onSearchNotesPressed(context),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  // Builds the Drawer menu with items like My Notes, Help & Support, and Logout
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            color: AppThemes
                .lightTheme()
                .primaryColor,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.favorite,
            title: S
                .of(context)
                .myNotes, // Translated text
            onTap: () => Navigator.pushNamed(context, '/myNote'),
          ),
          Divider(thickness: 0.5, color: Colors.grey),

          _buildDrawerItem(
            context,
            icon: Icons.delete,
            title: S
                .of(context)
                .deleteAllNotes, // Translated text
            onTap: () {},
          ),
          Divider(thickness: 0.5, color: Colors.grey),

          _buildDrawerItem(
            context,
            icon: Icons.help,
            title: S
                .of(context)
                .helpAndSupport, // Translated text
            onTap: () {},
          ),
          Divider(thickness: 0.5, color: Colors.grey),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: S
                .of(context)
                .setting,
            onTap: () =>
                Navigator.pushNamed(context, '/settings')
            ,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: S
                .of(context)
                .logout,
            // Translated text
            onTap:
                () =>
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).logout(context: context),
            iconColor: Colors.red,
            titleColor: Colors.red,
          ),
        ],
      ),
    );
  }

  // Builds the FloatingActionButton to create a new note
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed:
          () =>
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateUpdateNoteScreen(),
            ),
          ),
      child: const Icon(Icons.edit),
    );
  }

  // StreamBuilder for displaying notes from Firestore
  Widget _buildNotesStream(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestoreController().read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return _buildNotesGrid(context, snapshot.data!.docs);
        } else {
          return _buildEmptyNotesState(context);
        }
      },
    );
  }

  // Builds the GridView to display the notes
  Widget _buildNotesGrid(BuildContext context,
      List<QueryDocumentSnapshot> data,) {
    return RefreshIndicator(
      onRefresh:
          () => Provider.of<NoteProvider>(context, listen: false).onRefresh(),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildNoteCard(context, data[index], index);
        },
      ),
    );
  }

  // Creates a card for each note
  Widget _buildNoteCard(BuildContext context,
      QueryDocumentSnapshot noteData,
      int index,) {
    Color cardColor =
        Colors.primaries[index % Colors.primaries.length].shade100;

    return GestureDetector(
      onTap: () => _onTapNote(context, noteData),
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNoteHeader(context, noteData, index),
              const SizedBox(height: 8),
              _buildNoteDetails(noteData),
              const Spacer(),
              _buildNoteTimestamp(noteData),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the note header (title and popup menu for actions)
  Widget _buildNoteHeader(BuildContext context,
      QueryDocumentSnapshot noteData,
      int index,) {
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
        _buildPopupMenu(context, noteData, index),
      ],
    );
  }

  // Creates a popup menu with options (Delete and Add to Favorites)
  Widget _buildPopupMenu(BuildContext context,
      QueryDocumentSnapshot noteData,
      int index,) {
    return PopupMenuButton<String>(
      onSelected: (value) => _onPopupMenuSelected(context, value, noteData),
      itemBuilder:
          (BuildContext context) =>
      [
        _buildPopupMenuItem(
          context,
          value: 'delete',
          icon: Icons.delete,
          text: S
              .of(context)
              .delete,
        ),
        _buildPopupMenuItem(
          context,
          value: 'favorite',
          icon: Icons.bookmark_border,
          text: S
              .of(context)
              .addToFavorite,
        ),
      ],
      child: const Icon(Icons.more_vert, size: 18),
    );
  }

  // Builds individual PopupMenuItem for actions
  PopupMenuItem<String> _buildPopupMenuItem(BuildContext context, {
    required String value,
    required IconData icon,
    required String text,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  // Handles the selected action from the popup menu (Delete or Add to Favorites)
  Future<void> _onPopupMenuSelected(BuildContext context,
      String value,
      QueryDocumentSnapshot noteData,) async {
    if (value == 'delete') {
      await Provider.of<NoteProvider>(
        context,
        listen: false,
      ).deleteNote(context: context, noteId: noteData.id);
    } else if (value == 'favorite') {
      await _addToFavorites(context, noteData);
    }
  }

  // Adds the note to favorites
  Future<void> _addToFavorites(BuildContext context,
      QueryDocumentSnapshot noteData,) async {
    final favoriteNote = Note(
      id: noteData.id,
      title: noteData.get('title'),
      details: noteData.get('details'),
      createdAt: noteData.get('createdAt'),
    );

    await Provider.of<NoteProvider>(
      context,
      listen: false,
    ).updateFavoriteStatus(context: context, note: favoriteNote);
  }

  // Displays the note's details
  Widget _buildNoteDetails(QueryDocumentSnapshot noteData) {
    return Text(
      '${noteData.get('details')}',
      style: const TextStyle(fontSize: 14, color: Colors.black54),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Displays the note's creation timestamp
  Widget _buildNoteTimestamp(QueryDocumentSnapshot noteData) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        '${noteData.get('createdAt')}',
        style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
      ),
    );
  }

  // Displays a message when no notes are available
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
            S
                .of(context)
                .noNotes,
            style: const TextStyle(color: Colors.grey),
          ),
          // Translated text
        ],
      ),
    );
  }

  // Handles the note tap event (when the user clicks on a note)
  void _onTapNote(BuildContext context, QueryDocumentSnapshot noteData) {
    Provider.of<NoteProvider>(
      context,
      listen: false,
    ).onTapNote(context: context, snapshot: noteData);
  }

  // Handles the search notes action (search functionality)
  void _onSearchNotesPressed(BuildContext context) {
    Provider.of<NoteProvider>(
      context,
      listen: false,
    ).searchNotes(context: context);
  }

  // Creates a drawer item with icon and title
  ListTile _buildDrawerItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: titleColor)),
    );
  }
}
