import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScenarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeScenario(String scenario, List<String> options, List<String> players, List<String> interests, List<String> moods) async {
    if (scenario.isEmpty || options.isEmpty || players.isEmpty || interests.isEmpty || moods.isEmpty) {
      throw Exception('Invalid data: All fields must be non-empty.');
    }

    try {
      await _firestore.collection('scenarios').add({
        "scenario": scenario,
        "options": options,
        "players": players,
        "interests": interests,
        "moods": moods,
      });
    } catch (e) {
      // Log the error or handle it as needed
      print('Error when storing scenario: $e');
      //throw; // Rethrow the exception if you want to handle it further up the call stack.
    }
  }

  Future<Map<String, dynamic>?> fetchRandomScenario() async {
    try {
      final querySnapshot = await _firestore.collection('scenarios').get();
      if (querySnapshot.docs.isEmpty) return null;
      final randomDoc = querySnapshot.docs[Random().nextInt(querySnapshot.docs.length)];
      return randomDoc.data() as Map<String, dynamic>;
    } catch (e) {
      // Log the error or handle it as needed
      print('Error when fetching random scenario: $e');
      return null; // Return null or handle the error as appropriate.
    }
  }
}
