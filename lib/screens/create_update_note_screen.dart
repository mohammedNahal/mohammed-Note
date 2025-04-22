import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../model/note_model.dart';
import '../provider/note_provider.dart';

/// Create or update note screen.
/// - If [widget.note] exists, the fields are populated with the current note values.
/// - Otherwise, blank fields are shown for creating a new note.
class CreateUpdateNoteScreen extends StatefulWidget {
  const CreateUpdateNoteScreen({super.key, this.title = 'Create', this.note});

  /// The title of the screen ('Create' or 'Update')
  final String title;

  /// The existing note for update (can be null when creating a new note)
  final Note? note;

  @override
  State<CreateUpdateNoteScreen> createState() => _CreateUpdateNoteScreenState();
}

class _CreateUpdateNoteScreenState extends State<CreateUpdateNoteScreen> {
  late TextEditingController _titleController, _detailsController;
  late String _formattedDate;

  @override
  void initState() {
    super.initState();
    _titleController = widget.note == null ? TextEditingController() : TextEditingController(text: widget.note?.title ?? '');
    _detailsController = widget.note == null ? TextEditingController() : TextEditingController(text: widget.note?.details ?? '');
    _formattedDate = DateFormat(
      'EEEE, MMM d, yyyy • hh:mm a',
    ).format(DateTime.now());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.check_mark),
            onPressed: () {
              // Save the note and pass the current note (if any) as existingNote
              Provider.of<NoteProvider>(context, listen: false).saveNote(
                context: context,
                detailsController: _detailsController,
                titleController: _titleController,
                formattedDate: _formattedDate,
                noteId: widget.note?.id, // Pass the ID if the note exists
              );
              Navigator.pushReplacementNamed(context, '/home');
              clean();
            },
          ),
        ],
      ),
      // SafeArea to avoid overlapping with system's safe areas
      body: SafeArea(
        child: Consumer<NoteProvider>(
          builder: (_, provider, __) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // Title input field
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: S.of(context).title, // Using translation
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 8),

                // Display the formatted date and time when created/updated
                Text(
                  _formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Description input field
                TextField(
                  controller: _detailsController,
                  decoration: InputDecoration(
                    hintText: S.of(context).description, // Using translation
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void clean() {
    _titleController.text = '';
    _detailsController.text = '';
  }
}
