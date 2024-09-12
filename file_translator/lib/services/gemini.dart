import 'package:google_generative_ai/google_generative_ai.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

class Gemini {
  Gemini({required this.text});
  final String text;

  Future<String> generateText() async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: dotenv.env['API_KEY'] ?? '');
    final content = [
      Content.text(
          'Please translate the following text into Turkish. Provide only the translated text without any additional explanations, introductions, or comments, do not change structure of the text do not delete "@" mark: $text')
      // Content.text(
      //   'Please translate the following text into Turkish. Ensure that the text structure, line breaks, numbering, and any timestamps remain exactly as in the original text. Provide only the translated text without any additional explanations, introductions, or comments: \n\n$text',
      // ),
      // Content.text(
      //   'Please translate the following text into Turkish while preserving the exact formatting, including numbering, timestamps, and line breaks. Do not alter the structure in any way. Provide only the translated text without additional explanations, introductions, or comments: \n\n$text',
      // ),
    ];
    try {
      final response = await model.generateContent(content);
      return response.text ?? "";
    } catch (e) {
      return "Exception $e";
    }
  }
}
