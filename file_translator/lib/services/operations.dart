import 'dart:convert';
import 'package:path/path.dart' as p;
import 'gemini.dart';
import 'dart:math';

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

Future<void> saveToFile(
    {required String content, required String originalFilePath}) async {
  try {
    // Extract the directory, base name, and extension of the original file
    String directory = p.dirname(originalFilePath);
    String baseName = p.basenameWithoutExtension(originalFilePath);
    String extension = p.extension(originalFilePath); // Get the file extension

    // Construct the new file name with the same extension
    String newFilePath = p.join(directory, 'translated-$baseName$extension');

    // Write the translated cog(content);
    print("File saved to: $newFilePath");
  } catch (e) {
    print("Error saving file: $e");
  }
}

// Helper function to format file size
String formatBytes(int bytes, [int decimals = 2]) {
  if (bytes <= 0) return "0 B";

  const suffixes = ["Byte", "KB", "MB", "GB", "TB", "PB", "EB"];

  // Avoid index out of range error
  int i = (log(bytes) / log(1024)).floor();
  if (i >= suffixes.length)
    i = suffixes.length - 1; // Cap index to the suffixes list

  var size = (bytes / pow(1024, i)).toStringAsFixed(decimals);

  return '$size ${suffixes[i]}';
}
