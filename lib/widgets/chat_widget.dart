import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';



class ChatWidget extends StatelessWidget {
  final List<types.Message> messages;
  final types.User user;
  final Function(types.PartialText) onSendPressed;
  final Function() onAttachmentPressed;
  final Function() onGenerateScenario;
  // Add any other callbacks or parameters you need.

  const ChatWidget({
    Key? key,
    required this.messages,
    required this.user,
    required this.onSendPressed,
    required this.onAttachmentPressed,
    required this.onGenerateScenario,
    // Initialize other callbacks or parameters here.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: messages,
      onAttachmentPressed: onAttachmentPressed,
      onMessageTap: (context, message) {
        // Implement or pass the function to handle message taps.
      },
      onPreviewDataFetched: (message, previewData) {
        // Implement or pass the function to handle fetched preview data.
      },
      onSendPressed: (partialText) {
        onSendPressed(partialText);
      },
      showUserAvatars: true,
      showUserNames: true,
      user: user,
      // Any other customizations or parameters.

    );
  }
}
