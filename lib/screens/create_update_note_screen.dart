import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/note_model.dart';
import '../provider/note_provider.dart';

/// شاشة إنشاء أو تعديل الملاحظة
/// - إذا كان [widget.note] موجودًا، يتم تعبئة الحقول بالقيم الحالية للملاحظة.
/// - خلاف ذلك، تُعرض حقول فارغة لإضافة ملاحظة جديدة.
class CreateUpdateNoteScreen extends StatefulWidget {
  const CreateUpdateNoteScreen({super.key, this.title = 'Create', this.note});

  /// عنوان الشاشة ('Create' أو 'Update')
  final String title;

  /// الملاحظة الموجودة في حال التعديل (يمكن أن تكون null عند الإنشاء)
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
              // حفظ الملاحظة؛ يمرر الملاحظة الحالية (إن وجدت) كـ existingNote
              Provider.of<NoteProvider>(context,listen: false).saveNote(
                context: context,
                detailsController: _detailsController,
                titleController: _titleController,
                formattedDate: _formattedDate,
                noteId: widget.note?.id, // إذا كانت الملاحظة موجودة نمرر الـ ID
              );
              Navigator.pushReplacementNamed(context, '/home');
              clean();
            },
          ),
        ],
      ),
      // SafeArea لتجنب تداخل المحتوى مع حواف النظام
      body: SafeArea(
        child: Consumer<NoteProvider>(
          builder: (_, provider, __) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // حقل عنوان الملاحظة
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 8),

                // عرض التاريخ والوقت المهيأ عند الإنشاء/التعديل
                Text(
                  _formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // حقل تفاصيل الملاحظة
                TextField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
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

  void clean(){
    _titleController.text = '';
    _detailsController.text = '';
  }
}
