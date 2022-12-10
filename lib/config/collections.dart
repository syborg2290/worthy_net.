import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreRef = FirebaseFirestore.instance;
final DateTime timestamp = DateTime.now();
final usersRef = FirebaseFirestore.instance.collection('users');