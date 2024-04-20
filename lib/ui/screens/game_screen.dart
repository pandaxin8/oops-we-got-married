import 'package:flutter/material.dart';
import 'package:oops_we_got_married/services/gemini_service.dart';
import 'package:oops_we_got_married/services/scenario_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GeminiService _geminiService = GeminiService();
  final ScenarioService _scenarioService = ScenarioService();
  String _scenario = 'Loading...';
  bool _isLoading = false;

  void generateAndStoreScenario() async {
    setState(() { _isLoading = true; });
    try {
      final scenarioText = await _geminiService.generateScenario(['john', 'sally'], ['career', 'gaming'], ['silly', 'sarcastic']);
      await _scenarioService.storeScenario(scenarioText, ['Option 1', 'Option 2'], ['john', 'sally'], ['career', 'gaming'], ['silly', 'sarcastic']);
      setState(() {
        _scenario = scenarioText;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _scenario = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Game')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_scenario, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(),
              ElevatedButton(
                child: const Text('Generate + Store'),
                onPressed: generateAndStoreScenario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
