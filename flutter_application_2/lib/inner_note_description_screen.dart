import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class InnerNoteDescriptionScreen extends StatefulWidget {
  const InnerNoteDescriptionScreen({super.key});

  

  @override
  State<InnerNoteDescriptionScreen> createState() => _InnerNoteDescriptionScreenState();
}

class _InnerNoteDescriptionScreenState extends State<InnerNoteDescriptionScreen> {

  final FireStoreService fireStoreService = FireStoreService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();


  late final GenerativeModel model;

  @override
  void initState() {
    super.initState();
    const apiKey = 'AIzaSyC2OcmwW3wE2ka4QeVsUYsEbY8PHjBxeqQ';
      model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
  }

  // Function to generate title using Gemini
  Future<String> generateTitle(String content) async {
    try {
      final prompt = [
        Content.text('Generate a short title (maximum 3 words) for this note: $content')
      ];
      final response = await model.generateContent(prompt);
      return response.text?.trim() ?? 'Untitled Note';
    } catch (e) {
      print('Error generating title: $e');
      return 'Untitled Note';
    }
  }

  void handlenote() async{

    // If title is empty, generate one using the note content
    if (titleController.text.isEmpty && noteController.text.isNotEmpty) {
      String generatedTitle = await generateTitle(noteController.text);
      titleController.text = generatedTitle;
    }
    
    if(!mounted)  return;
    showDialog(context: context, builder: (context) =>
                  AlertDialog(
                    content: Text('Do you want to save this note?'),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Cancel')),
                      TextButton(onPressed: (){
                        fireStoreService.addNote(titleController.text, noteController.text);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }, child: Text('Yes')),
                    ],
                  )
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'Title',
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 24,
          fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){
              handlenote();

            },
          ),
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: noteController,
          decoration: InputDecoration(
            hintText: 'Enter your note here',
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 18),
          maxLines: null,
        ),
      ),),
    );
  }
}