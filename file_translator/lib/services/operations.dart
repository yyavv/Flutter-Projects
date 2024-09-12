import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'gemini.dart';

// Function to modify text by adding '@' to the end of each line
String modifyText(String content) {
  // Split the content by new lines
  List<String> lines = const LineSplitter().convert(content);

  // Append "@" to each line, excluding completely empty lines
  List<String> modifiedLines = lines.map((line) {
    // Trim the line to remove any extra spaces
    String trimmedLine = line.trim();

    // Append "@" to the trimmed line, or handle empty lines
    return trimmedLine.isNotEmpty ? "$trimmedLine @" : "";
  }).toList();

  // Join the modified lines with new line characters
  return modifiedLines.join('\n');
}

Future<String> translateText(String text) async {
  String result = '';
  result = await Gemini(text: text).generateText();
  //print(result);
  return result;
}

String removeMarks(String content) {
  return content.replaceAll('@', '');
}

Future<void> saveToFile(String content, String originalFilePath) async {
  try {
    // Extract the directory, base name, and extension of the original file
    String directory = p.dirname(originalFilePath);
    String baseName = p.basenameWithoutExtension(originalFilePath);
    String extension = p.extension(originalFilePath); // Get the file extension

    // Construct the new file name with the same extension
    String newFilePath = p.join(directory, 'translated-$baseName$extension');

    // Write the translated content to the new file
    File newFile = File(newFilePath);
    await newFile.writeAsString(content);

    print("File saved to: $newFilePath");
  } catch (e) {
    print("Error saving file: $e");
  }
}
