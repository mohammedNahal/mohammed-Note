
import 'package:final_project_note_app/model/note_model.dart';
import 'package:final_project_note_app/screens/create_update_note_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NoteSearchDelegate extends SearchDelegate<Note> {
  final List<Note> notes;
  final List<Note> history;

  NoteSearchDelegate({required this.notes}) : history = <Note>[];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      if (query.isEmpty)
        IconButton(
          onPressed: () {
            query = 'TODO: implement Voice input';
          },
          icon: Icon(CupertinoIcons.mic),
          tooltip: 'Voice Search',
        )
      else
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: Icon(CupertinoIcons.clear_thick),
          tooltip: 'Clear Query',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // Leading Icon in search bar
    return IconButton(
      onPressed: () {
        close(context, Note());
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      tooltip: 'Back',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Note> results = notes
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No Result',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return Card(
          color: Colors.teal.shade500,
          elevation: 7,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUpdateNoteScreen(
                    note: note,
                    title: 'Update',
                  ),
                ),
              );
            },
            title: Text(
              note.title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              note.details,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade300),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // show suggestions in context.
    final List<Note> suggestions = query.isEmpty
        ? history
        : notes.where((note) => note.title.toLowerCase().contains(query.toLowerCase())).toList();

    return SuggestionList(
      suggestions: suggestions,
      query: query,
      onSelected: (value) {
        query = value;
        print('title is $value');
        history.insert(0, suggestions[0]);
        showResults(context);
      },
    );
  }
}

class SuggestionList extends StatelessWidget {
  const SuggestionList({
    super.key,
    required this.suggestions,
    required this.query,
    required this.onSelected,
  });

  final List<Note> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(height: 10,),
            Card(
              elevation: 7,
              margin: EdgeInsets.symmetric(vertical: 5),
              color: Colors.white,
              child: ListTile(
                onTap: () {
                  onSelected(suggestions[index].title);
                },
                title: RichText(
                  text: TextSpan(
                    text: suggestions[index].title.substring(0, query.length),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade500,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: suggestions[index].title.substring(query.length),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  suggestions[index].details,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      },
      itemCount: suggestions.length,
    );
  }
}
