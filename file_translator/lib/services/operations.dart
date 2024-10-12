import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import '../components/custom_snackbar.dart';
import 'gemini.dart';
import 'dart:math';
import 'dart:io';

// // Function to modify text by adding '@' to the end of each line
// String modifyText(String content) {
//   // Split the content by new lines
//   List<String> lines = const LineSplitter().convert(content);
//
//   // Append "@" to each line, excluding completely empty lines
//   List<String> modifiedLines = lines.map((line) {
//     // Trim the line to remove any extra spaces
//     String trimmedLine = line.trim();
//
//     // Append "@" to the trimmed line, or handle empty lines
//     return trimmedLine.isNotEmpty ? "$trimmedLine @" : "";
//   }).toList();
//
//   // Join the modified lines with new line characters
//   return modifiedLines.join('\n');
// }

Future<String> translateText(String text) async {
  String result = '';
  result = await Gemini(text: text).generateText();
  //print(result);
  return result;
}

// String removeMarks(String content) {
//   return content.replaceAll('@', '');
// }

Future<void> saveToFile(
    {required String content, required String originalFilePath}) async {
  try {
    // Extract the directory, base name, and extension of the original file
    String directory = p.dirname(originalFilePath);
    String baseName = p.basenameWithoutExtension(originalFilePath);
    String extension = p.extension(originalFilePath); // Get the file extension

    // Construct the new file name with the same extension
    String newFilePath = p.join(directory, 'translated-$baseName$extension');

    // Write the content to the new file
    final file = File(newFilePath);
    await file.writeAsString(content);

    // Write the translated cog(content);
    print("File saved to: $newFilePath");
    showCustomSnackbar(
        message: "File saved to: $newFilePath",
        actionLabel: 'Open',
        onActionPressed: () async {
          final Uri fileUri =
              Uri.file(newFilePath); // Create a Uri from the file path

          if (await canLaunchUrl(fileUri)) {
            await launchUrl(fileUri);
          } else {
            print('Could not launch $newFilePath');
          }
        });
  } catch (e) {
    print("Error saving file: $e");
    showCustomSnackbar(message: "Error saving file: $e");
  }
}

List<String> createChunks(String content, int chunkSize) {
  List<String> lines = const LineSplitter().convert(content);
  List<String> chunks = [];
  List<String> currentChunk = [];

  for (String line in lines) {
    // Check if the line is a timestamp or an indicator
    if (RegExp(r'^\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}$')
        .hasMatch(line)) {
      // If the current chunk has enough lines, save it
      if (currentChunk.length >= chunkSize) {
        chunks.add(currentChunk.join('\n'));
        currentChunk = []; // Reset for the next chunk
      }
      // Add the timing line to the current chunk as the last line before the next timing
      currentChunk.add(line);
    } else {
      //if (line.isNotEmpty) {
      // Add non-empty lines to the current chunk
      currentChunk.add(line);
    }

    // If we have reached a timing line and we are about to add a new one, finalize the current chunk
    if (currentChunk.length >= chunkSize &&
        currentChunk.last.contains(
            RegExp(r'^\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}$'))) {
      chunks.add(currentChunk.join('\n'));
      currentChunk = [];
    }
  }

  // Add any remaining lines as a chunk if they exist
  if (currentChunk.isNotEmpty) {
    chunks.add(currentChunk.join('\n'));
  }

  print('Chunks: ${chunks.length}');
  return chunks;
}

Future<String> translateWithRetry(String chunk, {int retryCount = 3}) async {
  int attempt = 0;
  while (attempt < retryCount) {
    try {
      String translated = await translateText(chunk);
      if (translated.isNotEmpty) {
        return translated; // Return the successful translation
      }
    } catch (e) {
      print("Attempt ${attempt + 1} failed: $e");
    }
    attempt++;
  }
  return ''; // Return an empty string if all attempts fail
}
