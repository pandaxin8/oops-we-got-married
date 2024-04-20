import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String? apiKey = dotenv.env['API_KEY'];

  GeminiService() {
    if (apiKey == null) {
      throw Exception('API key is not set in the environment variables');
    }
  }

  Future<String> generateScenario(List<String> players, List<String> interests, List<String> moods) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);
    final content = [Content.text("""
    This is a lighthearted storytelling social game. Player names are ${players.join(', ')}. 
    They share interests in ${interests.join(', ')}, and tend to be in moods like ${moods.join(', ')}.
    Please create a scenario where their personalities clash humorously, leading to multiple choices in navigating the situation.
    """)];
    final response = await model.generateContent(content);
    return response.text ?? 'No scenario generated';
  }
}
