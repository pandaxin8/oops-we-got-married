import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oops_we_got_married/models/message.dart';



class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage(String text, String senderId, String receiverId) {
    var messagesRef = _firestore.collection('messages');
    messagesRef.add({
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': FieldValue.serverTimestamp(), // Uses server time
    });
  }

  Stream<List<Message>>? getMessagesStream() {
    var messagesRef = _firestore.collection('messages')
        .orderBy('timestamp', descending: true);  // Orders messages by timestamp

    return messagesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
