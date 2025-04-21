import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_note_app/model/note_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/firebase_firestore.dart';
import '../provider/note_provider.dart';

class MyNoteScreen extends StatefulWidget {
  const MyNoteScreen({super.key});

  @override
  State<MyNoteScreen> createState() => _MyNoteScreenState();
}

class _MyNoteScreenState extends State<MyNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestoreController().readFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<QueryDocumentSnapshot> data = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                Color cardColor =
                    Colors.primaries[index % Colors.primaries.length].shade100;
                return GestureDetector(
                  onTap:
                      () => Provider.of<NoteProvider>(
                        context,
                        listen: false,
                      ).onTapNote(context: context, snapshot: data[index]),
                  child: Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${data[index].get('title')}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'delete') {
                                    await Provider.of<NoteProvider>(
                                      context,
                                      listen: false,
                                    ).deleteNote(
                                      context: context,
                                      noteId: data[index].id,
                                    );
                                  }
                                },
                                itemBuilder:
                                    (BuildContext context) => [
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                child: Icon(Icons.more_vert, size: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${data[index].get('details')}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${data[index].get('createdAt')}',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.length,
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_calendar_outlined,
                    color: Colors.grey,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'The notes are empty.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
