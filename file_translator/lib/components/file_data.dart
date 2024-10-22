import 'dart:io';
import 'dart:math';
import 'package:charset/charset.dart';
import 'package:path/path.dart' as p;
import 'package:sub_translator/components/custom_snackbar.dart';
import 'dart:convert';
import 'dart:typed_data'; // For Uint8List

class FileData {
  String content = '';
  String? path;
  String? name;
  String size = '';
  bool isWeb = false;

  //Load file content
  Future<void> loadUsingPath(String path) async {
    File file = File(path);
    try {
      this.content = await file.readAsString();
      this.path = path;
      this.name = p.basename(path);
      this.size = formatBytes(file.lengthSync());
    } catch (e) {
      print('Error reading file: $e');
      showCustomSnackbar(message: 'Error reading file: $e');
      throw e;
    }
  }

  // Load file content from bytes for web version
  Future<void> loadForWeb(Uint8List bytes, String fileName) async {
    try {
      this.content = utf8.decode(bytes); // Decode the bytes to string
      this.name = fileName;
      this.size = formatBytes(bytes.length);
      //this.extension = p.extension(fileName); // Get extension from file name
      isWeb = true;
    } catch (e) {
      print('Error reading file: $e');
      throw e;
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
}
