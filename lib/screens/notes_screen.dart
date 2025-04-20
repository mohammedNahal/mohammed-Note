import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_note_app/firebase/firebase_firestore.dart';
import 'package:final_project_note_app/provider/user_provider.dart';
import 'package:final_project_note_app/screens/create_update_note_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/note_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Provider.of<NoteProvider>(
              context,
              listen: false,
            ).searchNotes(context: context),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/3,
            ),
            Divider(thickness: 0.5,color: Colors.grey,),
            ListTile(
              leading: Icon(Icons.favorite,),
              title: Text('My Note'),
            ),
            ListTile(
              leading: Icon(Icons.delete,),
              title: Text('Delete all Note'),
            ),
            ListTile(
              leading: Icon(Icons.help,),
              title: Text('Help & Support'),
            ),
            ListTile(
              onTap: () => Provider.of<UserProvider>(context, listen: false)
                  .logout(context: context),
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateUpdateNoteScreen()),
        ),
        child: Icon(Icons.edit),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestoreController().read(),
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
                  onTap: () => Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  ).onTapNote(
                    context: context,
                    snapshot: data[index],
                  ),
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
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
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
