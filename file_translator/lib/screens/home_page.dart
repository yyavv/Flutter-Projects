import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../services/operations.dart'; // Import this package

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String fileContent = '';
  String filePath = '';
  String? fileName;
  String fileSize = '';
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  String currentStage = 'Getting Data';
  bool isTranslationStarted = false;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        setState(() {}); // Rebuild UI on each frame of the animation
      });

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

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
          fileName = path.basename(filePath);
          fileSize = formatBytes(file.lengthSync());
          _animationController.reset();
          currentStage = 'Getting Data...';
          isTranslationStarted = false;
        });
      } else {
        print("No file selected or user canceled the picker.");
      }
    } catch (e) {
      print("Error selecting file: $e");
    }
  }

  Future<void> translate() async {
    setState(() {
      isTranslationStarted = true;
      _updateProgress(0.1); // Start animation to 10%
      currentStage = 'Getting Data...';
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate getting data

    // Process the file content and print modified content
    String modifiedContent = modifyText(fileContent);

    setState(() {
      currentStage = 'Translating...';
      _startProgressIncrement(0.3, 0.6); // Gradually increase from 30% to 60%
    });

    String text = await translateText(modifiedContent);

    setState(() {
      currentStage = 'Reformatting...';
      _updateProgress(0.6); // Animate to 60%
    });
    await Future.delayed(Duration(seconds: 1)); // Simulate reformatting time
    text = removeMarks(text);
    print(text);

    setState(() {
      currentStage = 'Writing and Saving...';
      _updateProgress(0.9); // Animate to 90%
    });
    await Future.delayed(Duration(seconds: 1)); // Simulate saving time
    await saveToFile(text, filePath);

    setState(() {
      currentStage = 'Finished...';
      _updateProgress(1.0); // Complete the animation to 100%
    });

    _stopProgressIncrement();
  }

  void _updateProgress(double newProgress) {
    _animationController.animateTo(newProgress, duration: Duration(seconds: 1));
  }

  void _startProgressIncrement(double start, double end) {
    _progressTimer?.cancel(); // Cancel any existing timer
    double increment = 0.01; // Progress increment step
    double currentProgress = start;

    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (currentProgress >= end) {
        timer.cancel();
        return;
      }
      currentProgress += increment;
      setState(() {
        _updateProgress(currentProgress);
      });
    });
  }

  void _stopProgressIncrement() {
    _progressTimer?.cancel();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (fileName == null)
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Pick a Text File'),
              ),
            if (fileName != null)
              Column(
                children: [
                  Text(
                    '$fileName',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$fileSize',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Change File'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: translate,
                    child: const Text('Translate'),
                  ),
                  SizedBox(height: 40),
                  Visibility(
                    visible: isTranslationStarted,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: _progressAnimation.value,
                          minHeight: 12.0,
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(5)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentStage,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
//TODO: islem tamamlandiginda dosyayi acma seceneginin olmasi ve basarili bir sekilde yapildiginin anlatilmasi
//TODO: yeni dosyanin ismi ve konumu
//TODO: uygulama mobilde tam verimli calismiyor mobil icin tekrar kontrol ve kod yazilmasi
//TODO: destkop uygulama kotu gozukuyor, genel bir tasarim duzenlenmesi
//TODO: dil secme yeri ve islemlerin o dil uzerinden yapilmasi
//TODO: butonlarin ve genel stilin tekrar tasarlanmasi
