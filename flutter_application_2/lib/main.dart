import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_application_2/inner_note_description_screen.dart';
import 'package:flutter_application_2/services/firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'AptNote',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InnerNoteDescriptionScreen(),
              ),
            );
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FireStoreService().getNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.data == null) {
                      return Center(child: Text('No notes found'));
                    }
                    var notes = snapshot.data!.docs.where((note) {
                        var title = note['title'].toString().toLowerCase();
                        var content = note['note'].toString().toLowerCase();
                        return title.contains(searchQuery) || content.contains(searchQuery);
                      }).toList();

                    return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        var note = notes[index];
                        var title = note['title'];
                        var noteText = note['note'];
                        var id = note.id;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent, // Move color here
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(title),
                              subtitle: Text(noteText),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  final navigator = Navigator.of(context);
                                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          content: const Text("Do you want to delete this note?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                navigator.pop(); // Close dialog
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                try {
                                                  await FireStoreService().deleteNote(id);
                                                  navigator.pop();
                                                  scaffoldMessenger.showSnackBar(
                                                    const SnackBar(content: Text('Note deleted successfully')),
                                                  );
                                                } catch (e) {
                                                  navigator.pop();
                                                  scaffoldMessenger.showSnackBar(
                                                    SnackBar(content: Text('Error deleting note: $e')),
                                                  );
                                                }
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        ),
                                      );
                                },
                              ),
                              
                            ),
                          ),
                        );
                      },
                    );
                  }),
            )
          ],
        )));
  }
}
