import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/operations.dart'; // Import this package

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fileContent = '';
  String filePath = '';

  Future<void> _pickFile() async {
    try {
      // Use FilePicker to pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'srt'],
      );

      if (result != null && result.files.single.path != null) {
        // Read the content of the selected file
        File file = File(result.files.single.path!);
        String content = await file.readAsString();

        // Update state with file content and path
        setState(() {
          fileContent = content;
          filePath = result.files.single.path!;
        });

        // Process the file content and print modified content
        String modifiedContent = modifyText(content);

        // Call translation function after modifying text
        String text = await translateText(modifiedContent);

        text = removeMarks(text);
        print(text);

        // Save modified content to a new file
        await saveToFile(text, filePath);
      } else {
        // User canceled the picker
        print("No file selected or user canceled the picker.");
      }
    } catch (e) {
      print("Error selecting file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text File Operations'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickFile,
          child: const Text('Pick a Text File'),
        ),
      ),
    );
  }
}

//TODO: dosya yukeldikten sonra dosyanin adi ve uzantisi ve boyutu
//TODO: yukelenen dosyasi silme
//TODO: dosya yukledikten sonra cevir butonu ve o buton kullanilarak api request yapilmasi
//TODO: islemler gerceklesirken bir yukeleme ekrani ve hangi asamada oldugunu gosteren bir isaret
//TODO: islem tamamlandiginda dosyayi acma seceneginin olmasi ve basarili bir sekilde yapildiginin anlatilmasi
//TODO: yeni dosyanin ismi ve konumu
