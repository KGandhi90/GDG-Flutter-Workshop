import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  //get collection
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  //Create
  Future<void> addNote(String title, String note ){
    return notes.add({
      'title': title,
      'note': note,
      'timestamp': DateTime.now()
    });
  }

  //Read
  Stream<QuerySnapshot> getNotes(){
    final allNotes = notes.orderBy('timestamp', descending: true).snapshots();
    return allNotes;
  }

  //Update
  Future<void> updateNote(String noteId, String title, String note){
    return notes.doc(noteId).update({
      'title': title,
      'note': note,
      'timestamp': DateTime.now()
    });
  }

  //Delete
  Future<void> deleteNote(String noteId){
    return notes.doc(noteId).delete();
  }


}