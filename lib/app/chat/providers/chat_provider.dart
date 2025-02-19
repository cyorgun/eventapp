import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;
  final String otherUserId;

  ChatProvider({required this.userId, required this.otherUserId});

  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;
    await _firestore.collection('chats').doc(_getChatId()).collection('messages').add({
      'text': message,
      'senderId': userId,
      'receiverId': otherUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  String _getChatId() {
    return userId.hashCode <= otherUserId.hashCode
        ? '$userId\_$otherUserId'
        : '$otherUserId\_$userId';
  }
}