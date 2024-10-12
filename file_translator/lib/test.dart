import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sub_translator/components/file_content_display.dart';
import 'package:sub_translator/services/operations.dart';

import 'components/custom_snackbar.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final Stopwatch stopwatch = Stopwatch();
  String fileContent = '';
  String filePath = '';
  String left = 'left';
  String? right;
  String translatedText = '';
  List<String> onlyTiming = [];

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'srt'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();

        setState(() {
          fileContent = content;
          filePath = result.files.single.path!;
          left = fileContent;
        });
      } else {
        print("No file selected or user canceled the picker.");
        showCustomSnackbar(
          message: 'No file selected!',
        );
      }
    } catch (e) {
      print("Error selecting file: $e");
      showCustomSnackbar(
        message: 'Error selecting file: $e',
      );
    }
  }

  // List<List<String>> createChunks(String content, int chunkSize) {
  //   // Split the content by new lines
  //   List<String> lines = const LineSplitter().convert(content);
  //
  //   // Create a list to hold the chunks
  //   List<List<String>> chunks = [];
  //
  //   // Temporary list for the current chunk
  //   List<String> currentChunk = [];
  //
  //   for (String line in lines) {
  //     // Trim the line to remove any extra spaces
  //     String trimmedLine = line.trim();
  //
  //     // If the line is not empty, add it to the current chunk
  //     if (trimmedLine.isNotEmpty) {
  //       currentChunk.add(trimmedLine); // No "@" appended
  //     }
  //
  //     // If we reach the chunk size, save the current chunk and start a new one
  //     if (currentChunk.length >= chunkSize) {
  //       chunks.add(currentChunk);
  //       currentChunk = []; // Start a new chunk
  //     }
  //   }
  //
  //   // Add any remaining lines in the current chunk
  //   if (currentChunk.isNotEmpty) {
  //     chunks.add(currentChunk);
  //   }
  //
  //   return chunks;
  // }

  // List<String> createChunks(String content, int chunkSize) {
  //   // Split the content by new lines
  //   List<String> lines = const LineSplitter().convert(content);
  //
  //   // Create a list to hold the chunks
  //   List<String> chunks = [];
  //
  //   // Temporary list for the current chunk
  //   List<String> currentChunk = [];
  //
  //   for (String line in lines) {
  //     // Trim the line to remove any extra spaces
  //     String trimmedLine = line.trim();
  //
  //     // If the line is not empty, add it to the current chunk
  //     // if (trimmedLine.isNotEmpty) {
  //     currentChunk.add(trimmedLine);
  //     //}
  //
  //     // If we reach the chunk size, save the current chunk as a joined string
  //     if (currentChunk.length >= chunkSize) {
  //       chunks.add(currentChunk.join('\n'));
  //       currentChunk = []; // Start a new chunk
  //     }
  //   }
  //
  //   // Add any remaining lines in the current chunk as a joined string
  //   if (currentChunk.isNotEmpty) {
  //     chunks.add(currentChunk.join('\n'));
  //   }
  //
  //   return chunks;
  // // }
  //
  // List<String> createChunks(String content, int chunkSize) {
  //   List<String> lines = const LineSplitter().convert(content);
  //   List<String> chunks = [];
  //   List<String> currentChunk = [];
  //   int i = 1;
  //   int chunkMarkCounter = 0;
  //   bool lastValid = false; // to check if line ends with a |
  //
  //   stopwatch.start();
  //   for (String line in lines) {
  //     lastValid = false;
  //     // Check if the line is a timestamp or an indicator
  //     if (RegExp(r'^\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}$')
  //         .hasMatch(line)) {
  //       onlyTiming.add('${i++}\n' + line + '\n');
  //       if (currentChunk.isNotEmpty) {
  //         currentChunk
  //             .removeLast(); // remove the number that indicates order in subtitle
  //       }
  //       if (currentChunk.isNotEmpty) {
  //         currentChunk[currentChunk.length - 1] += '\n|\n|';
  //         chunkMarkCounter++;
  //         lastValid = true;
  //       }
  //     } else if (line.isNotEmpty) {
  //       currentChunk.add(line);
  //     }
  //
  //     // If we reach the chunk size, save the current chunk as a joined string
  //     if (currentChunk.length >= chunkSize && lastValid) {
  //       chunks.add(currentChunk.join('\n'));
  //       currentChunk = [];
  //     }
  //   }
  //
  //   if (currentChunk.isNotEmpty) {
  //     chunks.add(currentChunk.join('\n'));
  //   }
  //   // stopwatch.stop();
  //   // print(onlyTiming);
  //   // print('obje isleme: ${stopwatch.elapsedMilliseconds}');
  //   // stopwatch.reset();
  //   setState(() {
  //     //right = chunks.toString();
  //   });
  //   print('Only Timing: ${onlyTiming.length}');
  //   //print('Chunks: ${chunks[0]}');
  //
  //   print("Number of | in chunks $chunkMarkCounter");
  //   return chunks;
  // }

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
          currentChunk.last.contains(RegExp(
              r'^\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}$'))) {
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

  List<String> createeChunks(String content, int chunkSize) {
    List<String> lines = const LineSplitter().convert(content);
    List<String> chunks = [];
    List<String> currentChunk = [];
    int i = 1;
    int chunkMarkCounter = 0;
    bool lastValid = false; // to check if line ends with a |

    stopwatch.start();
    for (String line in lines) {
      lastValid = false;
      // Check if the line is a timestamp or an indicator
      if (RegExp(r'^\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}$')
          .hasMatch(line)) {
        onlyTiming.add('${i++}\n' + line + '\n');
        if (currentChunk.isNotEmpty) {
          currentChunk
              .removeLast(); // remove the number that indicates order in subtitle
        }
        if (currentChunk.isNotEmpty) {
          currentChunk[currentChunk.length - 1] += '\n|\n|';
          chunkMarkCounter++;
          lastValid = true;
        }
      } else if (line.isNotEmpty) {
        currentChunk.add(line);
      }

      // If we reach the chunk size, save the current chunk as a joined string
      if (currentChunk.length >= chunkSize && lastValid) {
        chunks.add(currentChunk.join('\n'));
        currentChunk = [];
      }
    }

    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk.join('\n'));
    }
    // stopwatch.stop();
    // print(onlyTiming);
    // print('obje isleme: ${stopwatch.elapsedMilliseconds}');
    // stopwatch.reset();
    setState(() {
      //right = chunks.toString();
    });
    print('Only Timing: ${onlyTiming.length}');
    //print('Chunks: ${chunks[0]}');

    print("Number of | in chunks $chunkMarkCounter");
    return chunks;
  }

  Future<void> translate() async {
    List<String> chunks = createChunks(fileContent, 400);
    String response = '';
    int count = 0;
    int i = 0;
    for (int index = 0; index < chunks.length; index++) {
      print(i++);
      stopwatch.start();
      //response += await translateWithRetry(chunks[index]);
      response += chunks[index];
      stopwatch.stop();
      count += stopwatch.elapsedMilliseconds;
      stopwatch.reset();
    }

    // print("Elapsed Time: ${count} seconds");

    setState(() {
      translatedText = response;
      right = translatedText;
    });
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

  // String reBuild(String content) {
  //   List<String> lines = LineSplitter().convert(content);
  //   String text = '';
  //
  //   int timingIndex = 0; // Initialize timing index
  //   StringBuffer currentGroup =
  //       StringBuffer(); // To accumulate lines until the next '|'
  //
  //   for (var line in lines) {
  //     if (line.isNotEmpty) {
  //       // If the line is a separator '|', handle the current group
  //       if (line.trim() == '|') {
  //         if (currentGroup.isNotEmpty) {
  //           // Add the current group of lines to the text
  //           if (timingIndex < onlyTiming.length) {
  //             text += onlyTiming[timingIndex++]; // Add timing
  //           }
  //           text += currentGroup.toString().trim() +
  //               '\n\n'; // Add lines and two newlines
  //           currentGroup.clear(); // Clear for the next group
  //         }
  //       } else {
  //         // Accumulate the line, removing any '|' marks
  //         currentGroup.write(line.replaceAll('|', '').trim() + '\n');
  //       }
  //     }
  //   }
  //
  //   // Add any remaining lines after the last separator
  //   if (currentGroup.isNotEmpty && timingIndex < onlyTiming.length) {
  //     text += onlyTiming[timingIndex++];
  //     text += currentGroup.toString().trim() + '\n\n';
  //   }
  //
  //   return text.trim(); // Trim to remove any trailing newlines
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _pickFile, child: Text('Select file')),
            ElevatedButton(onPressed: translate, child: Text('translate')),
            SizedBox(height: 20),
            SizedBox(height: 20),
            if (right != null)
              FileContentDisplay(
                fileContentLeft: left,
                initialFileContentRight: right ?? '',
                onTextChanged: (text) {
                  setState(() {
                    right = text;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
