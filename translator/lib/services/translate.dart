import 'package:google_generative_ai/google_generative_ai.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

class Translator {
  Translator({required this.text, required this.start, required this.dest});
  final String text;
  final String start;
  final String dest;
  final String _apiKey = "AIzaSyDQH2DQ-2DtSnDpKp9n8rgIzbAfEZoJ6OU";

  Future<String> generateText() async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: dotenv.env['API_KEY'] ?? '');
    final content = [
      Content.text(
          'Please translate the following text into $dest. Provide only the translated text without any additional explanations, introductions, or comments: $text')
    ];
    try {
      final response = await model.generateContent(content);
      return response.text ?? "";
    } catch (e) {
      return "Exception $e";
    }
  }
}
