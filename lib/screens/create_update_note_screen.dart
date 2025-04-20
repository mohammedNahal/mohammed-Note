import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/note_model.dart';
import '../provider/note_provider.dart';

/// شاشة إنشاء أو تعديل الملاحظة
/// - إذا كان [widget.note] موجودًا، يتم تعبئة الحقول بالقيم الحالية للملاحظة.
/// - خلاف ذلك، تُعرض حقول فارغة لإضافة ملاحظة جديدة.
class CreateUpdateNoteScreen extends StatefulWidget {
  const CreateUpdateNoteScreen({
    super.key,
    this.title = 'Create',
    this.note,
  });

  /// عنوان الشاشة ('Create' أو 'Update')
  final String title;

  /// الملاحظة الموجودة في حال التعديل (يمكن أن تكون null عند الإنشاء)
  final Note? note;

  @override
  State<CreateUpdateNoteScreen> createState() => _CreateUpdateNoteScreenState();
}

class _CreateUpdateNoteScreenState extends State<CreateUpdateNoteScreen> {
  late final NoteProvider _noteProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // نحصل على مزود NoteProvider للاستخدام لاحقًا
    _noteProvider = Provider.of<NoteProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<NoteProvider>(context, listen: false).initCreateUpdate(
      initialTitle: widget.note?.title ?? '',
      initialDetails: widget.note?.details ?? '',
    );
  }

  @override
  void dispose() {
    // نتخلص من الكنترولرز الخاصة بالإنشاء/التعديل
    _noteProvider.disposeCreateUpdate();
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
              _noteProvider.saveNote(
                context: context,
                noteId: widget.note?.id, // إذا كانت الملاحظة موجودة نمرر الـ ID
              );
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
                  controller: provider.titleController,
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
                  provider.formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // حقل تفاصيل الملاحظة
                TextField(
                  controller: provider.detailsController,
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
}
