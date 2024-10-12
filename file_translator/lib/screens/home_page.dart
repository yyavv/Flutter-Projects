import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sub_translator/components/custom_snackbar.dart';

import '../components/language/language.dart' as L;
import '../components/file_content_display.dart';
import '../components/file_data.dart';
import '../components/language/language_picker.dart';
import '../services/operations.dart'; // Import this package

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  FileData file = FileData();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  String currentStage = 'Getting Data';
  bool isTranslationStarted = false;
  Timer? _progressTimer;

  String translatedText = '';

  // to check if select file operation has been started to activate loading animation
  bool isFileSelected = false;

  int numberOfChunks = 0;

  int _selectedStart = 0;
  int _selectedDest = 1;

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
    setState(() {
      // to start loading indicator
      file = FileData();
      isFileSelected = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'srt'],
      );

      if (result != null && result.files.single.path != null) {
        file.load(result.files.single.path!);

        setState(() {
          //fileContent = content;
          //filePath = result.files.single.path!;
          //fileName = path.basename(filePath);
          //fileSize = formatBytes(file.lengthSync());
          _animationController.reset();
          currentStage = 'Getting Data...';
          isTranslationStarted = false;
          isFileSelected = false; // End loading
        });
      } else {
        print("No file selected or user canceled the picker.");
        showCustomSnackbar(message: 'No file selected!');
        setState(() {
          isFileSelected = false; // End loading
        });
      }
    } catch (e) {
      print("Error selecting file: $e");
      showCustomSnackbar(message: 'Error selecting file: $e');
      setState(() {
        isFileSelected = false; // End loading
      });
    }
  }

  Future<void> translate() async {
    String response = '';
    setState(() {
      isTranslationStarted = true;
      _updateProgress(0.1); // Start animation to 10%
      currentStage = 'Getting Data...';
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate getting data

    // Create chunks
    List<String> chunks = createChunks(file.content, 400);
    numberOfChunks = chunks.length;

    setState(() {
      currentStage = 'Translating...';
      _updateProgress(0.2); // Initial progress for translation
    });

    for (int index = 0; index < numberOfChunks; index++) {
      print(index + 1);
      response += await translateWithRetry(chunks[index]);

      // Calculate and update progress after each response
      double progressIncrement = 0.8 /
          numberOfChunks; // Remaining progress (80%) divided by number of chunks
      setState(() {
        double currentProgress = 0.2 +
            (index + 1) * progressIncrement; // 0.3 is the starting progress
        _updateProgress(currentProgress);
      });
    }

    setState(() {
      currentStage = 'Reformatting...';
      _updateProgress(0.8); // Animate to 80% after translation
    });

    setState(() {
      translatedText = response;
      currentStage = 'Writing and Saving...';
      _updateProgress(0.9); // Animate to 90%
    });
  }

  void _updateProgress(double newProgress) {
    _animationController.animateTo(newProgress, duration: Duration(seconds: 1));
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

  void _swapLanguages() {
    setState(() {
      int temp = _selectedStart;
      _selectedStart = _selectedDest;
      _selectedDest = temp;
    });
  }

  void _handleStartLanguageChanged(int selectedItem) {
    setState(() {
      if (selectedItem == _selectedDest) {
        _selectedDest = _selectedStart;
      }
      _selectedStart = selectedItem;
    });
  }

  void _handleDestLanguageChanged(int selectedItem) {
    setState(() {
      if (selectedItem == _selectedStart) {
        _selectedStart = _selectedDest;
      }
      _selectedDest = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1A1423),
        flexibleSpace: SafeArea(
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LanguagePicker(
                  selectedLanguage: _selectedStart,
                  onSelectedItemChanged: _handleStartLanguageChanged,
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: _swapLanguages,
                  icon: const Icon(
                    CupertinoIcons.arrow_right_arrow_left_circle_fill,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                LanguagePicker(
                  selectedLanguage: _selectedDest,
                  onSelectedItemChanged: _handleDestLanguageChanged,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isFileSelected)
              Center(
                child: SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    strokeWidth: 8.0,
                  ),
                ),
              ),
            if (file.name == null && !isFileSelected)
              Center(
                child: ElevatedButton(
                  onPressed: _pickFile,
                  child: const Text('Pick a Text File'),
                ),
              ),
            if (file.name != null && !isFileSelected)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${file.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${file.size}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: const Text('Change File'),
                    ),
                    const SizedBox(height: 10),
                    isTranslationStarted
                        ? ElevatedButton(
                            onPressed: () async {
                              try {
                                await saveToFile(
                                    content: translatedText,
                                    originalFilePath: file.path);

                                setState(() {
                                  currentStage = 'Finished...';
                                  _updateProgress(
                                      1.0); // Complete the animation to 100%
                                });

                                _stopProgressIncrement();
                              } catch (e) {
                                print("Error saving the file: $e");
                                showCustomSnackbar(
                                    message: "Error saving the file: $e");
                              }
                            },
                            child: const Text('Save to File'),
                          )
                        : ElevatedButton(
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
                    const SizedBox(height: 30),

                    // New component to display the file content
                    //if (currentStage == 'Writing and Saving...')
                    if (file.name != null)
                      FileContentDisplay(
                        fileContentLeft: file.content,
                        initialFileContentRight: translatedText,
                        onTextChanged: (text) {
                          setState(() {
                            translatedText = text;
                            //print(translatedText);
                          });
                        },
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
//TODO: bir snack bar eklenip her durumdan sonra bir bilgi mesaji goruntulenmesi
//TODO: change file tusu duzgun calismiyor
//TODO: islem tamamlandiginda dosyayi acma seceneginin olmasi ve basarili bir sekilde yapildiginin anlatilmasi
//TODO: yeni dosyanin ismi ve konumu
//TODO: uygulama mobilde tam verimli calismiyor mobil icin tekrar kontrol ve kod yazilmasi
//TODO: destkop uygulama kotu gozukuyor, genel bir tasarim duzenlenmesi
//TODO: dil secme yeri ve islemlerin o dil uzerinden yapilmasi
//TODO: butonlarin ve genel stilin tekrar tasarlanmasi
