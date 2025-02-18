import 'package:flutter/material.dart';

class UpdateNoteDescriptionScreen extends StatelessWidget {
  const UpdateNoteDescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your note here',
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 18),
          maxLines: null,
        ),
      ),
      ),
    );
  }
}