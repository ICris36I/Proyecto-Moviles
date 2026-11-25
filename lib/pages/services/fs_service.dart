import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  Stream<QuerySnapshot> publicaciones(){
    return FirebaseFirestore.instance.collection('Publicaciones').snapshots();
  }

}