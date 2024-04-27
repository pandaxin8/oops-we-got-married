import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oops_we_got_married/firebase_options.dart';
import 'package:oops_we_got_married/models/message.dart';
import 'package:oops_we_got_married/services/chat_service.dart';
import 'package:oops_we_got_married/ui/screens/sign_in_page.dart';
import 'package:uuid/uuid.dart';
import 'package:oops_we_got_married/services/gemini_service.dart';
import 'package:oops_we_got_married/widgets/chat_widget.dart'; // Ensure this path is correct


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );              // Initialize Firebase
  await dotenv.load(fileName: ".env");
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // User is signed in
              return const ChatPage();
            }
            // User is not signed in
            return SignInPage();
          }
          // Waiting for authentication state to be available
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late final GeminiService _geminiService;
  late final types.User _user; // Assume a user setup is necessary
  late final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(); // Initialize your GeminiService
    _user = types.User(id: const Uuid().v4()); // Initialize user with unique ID
    _loadInitialMessages(); // Load initial messages if any
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message); // Insert new message at the start of the list
    });
  }

  void _onSendPressed(types.PartialText partialText) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: partialText.text,
    );
    _addMessage(textMessage);
    _chatService.sendMessage(textMessage.text, _user.id, 'chatroomID'); 
    // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // var messagesRef = _firestore.collection('messages');
    // messagesRef.add({
    //   'text': textMessage.text,
    //   'senderId': _user.id,
    //   'receiverId': 'chatroomID',
    //   'timestamp': FieldValue.serverTimestamp(), // Uses server time
    // });

  }

  void _onGenerateScenarioPressed() async {
    final scenarioText = await _geminiService.generateScenario(
      ['Alice', 'Bob'], // Example names
      ['gaming', 'reading'], // Example interests
      ['excited', 'curious'] // Example moods
    );
    _addMessage(types.TextMessage(
      author: types.User(id: 'system'), // System or game master user
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: scenarioText,
    ));
  }

  void _loadInitialMessages() {
    // Here you would load messages from a local store or remote database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatWidget(
        messages: _messages,
        user: _user,
        onSendPressed: _onSendPressed,
        onAttachmentPressed: () {
          // Logic to handle when attachment button is pressed
        },
        onGenerateScenario: _onGenerateScenarioPressed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onGenerateScenarioPressed,
        child: const Icon(Icons.casino),
        tooltip: 'Generate Scenario',
      ),
    );
  }
}
