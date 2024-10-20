import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final Stopwatch stopwatch = Stopwatch();

  FileData file = FileData();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  String currentStage = 'Getting Data';
  bool isTranslationStarted =
      false; // to keep track of the stages and progress animation
  Timer? _progressTimer;

  String translatedText = '';

  // to check if select file operation has been started to activate loading animation
  bool isFileSelected = false;

  int numberOfChunks = 0;

  int _selectedStart = 0;
  int _selectedDest = 1;

  bool hasErrorOccurred = false;

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
        await file.load(result.files.single.path!);

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
      throw e;
    }
  }

  Future<void> translate() async {
    //Initialize State
    setState(() {
      hasErrorOccurred = false;
      translatedText = '';
      isTranslationStarted = true;
      _updateProgress(0.1); // Start animation to 10%
      currentStage = 'Getting Data...';
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate getting data

    // Create chunks
    List<String> chunks = createChunks(file.content, 650);
    numberOfChunks = chunks.length;

    List<String> responses = List<String>.filled(numberOfChunks, '');

    setState(() {
      currentStage = 'Translating...';
      _updateProgress(0.2); // Initial progress for translation
    });

    stopwatch.reset();
    stopwatch.start();

    double progressIncrement = 0.8 /
        numberOfChunks; // Remaining progress (80%) divided by number of chunks
    int incomingResponseCount = 0;

    final futures = List<Future<void>>.generate(numberOfChunks, (index) async {
      responses[index] = await translateWithRetry(
          chunks[index], index, L.Language.getNameByIndex(_selectedDest));
      Future.delayed(Duration(milliseconds: 500));

      if (responses[index].isEmpty) {
        isTranslationStarted = false;
        hasErrorOccurred = true;
        showCustomSnackbar(
            message:
                'Request has been canceled due to server error. Try again after some time.');
      }

      /// code for testing
      // responses[index] = chunks[index];
      print(index + 1);
      incomingResponseCount++;

      setState(() {
        double currentProgress =
            0.2 + incomingResponseCount * progressIncrement; // Start from 0.2
        _updateProgress(currentProgress);
      });
    });

    await Future.wait(futures);

    setState(() {
      currentStage = 'Reformatting...';
      _updateProgress(0.8); // Animate to 80% after translation
    });

    setState(() {
      responses.forEach((response) {
        translatedText += response;
      });
      currentStage = 'Writing and Saving...';
      _updateProgress(0.9); // Animate to 90%
      showCustomSnackbar(
          message: 'Content translated in ${stopwatch.elapsed.inSeconds}s');
    });

    stopwatch.stop();
    print(stopwatch.elapsedMilliseconds);
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LanguagePicker(
                  selectedLanguage: _selectedStart,
                  onSelectedItemChanged: _handleStartLanguageChanged,
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _swapLanguages,
                  icon: const Icon(
                    CupertinoIcons.arrow_right_arrow_left_circle_fill,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
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
                              onPressed: (currentStage ==
                                      'Writing and Saving...')
                                  ? () async {
                                      try {
                                        await saveToFile(
                                          content: translatedText,
                                          originalFilePath: file.path,
                                          language: L.Language.getNameByIndex(
                                              _selectedDest),
                                        );

                                        setState(() {
                                          currentStage = 'Finished...';
                                          _updateProgress(
                                              1.0); // Complete the animation to 100%
                                        });

                                        _stopProgressIncrement();
                                      } catch (e) {
                                        print("Error saving the file: $e");
                                        showCustomSnackbar(
                                            message:
                                                "Error saving the file: $e");
                                      }
                                    }
                                  : () {
                                      showCustomSnackbar(
                                          message:
                                              'Data is not ready to Save!');
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
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 1200),
                              child: LinearProgressIndicator(
                                value: _progressAnimation.value,
                                minHeight: 12.0,
                                borderRadius: BorderRadiusDirectional.all(
                                    Radius.circular(5)),
                              ),
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
                      if (currentStage == 'Writing and Saving...' &&
                          isTranslationStarted)
                        //if (file.name != null)
                        FileContentDisplay(
                          fileContentLeft: file.content,
                          initialFileContentRight: translatedText,
                          onTextChanged: (text) {
                            setState(() {
                              translatedText = text;
                              //print(translatedText);
                            });
                          },
                          l1: L.Language.getNameByIndex(_selectedStart),
                          l2: L.Language.getNameByIndex(_selectedDest),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: farkli dosya formatlarini okuyamiyor sadece UTF8
//TODO: butonlarin ve genel stilin tekrar tasarlanmasi
//TODO: uygulama mobilde tam verimli calismiyor mobil icin tekrar kontrol ve kod yazilmasi
//TODO: destkop uygulama kotu gozukuyor, genel bir tasarim duzenlenmesi

/// Completed ToDoS
//TODO: her chunktan sonra progress indicatorin arttirilmasi - added incomingResponseCount to keep count of the response
//TODO: change file tusu duzgun calismiyor - yukleme kismina await eklendi ve sorunun onune gecildi
//TODO: dil secme yeri ve islemlerin o dil uzerinden yapilmasi
//TODO: attemp sayisi 3 olan herhangi bir chunk varsa hata mesaji gosterilip islemin iptal edilmesi
//TODO: ikinci bir translate istendigi zaman ilkinin uzerine ekliyor oncekini silmiyor
//TODO: program sequential bir sekilde calisiyor gibi paralel programing yok
//TODO: ozellikle pc versiyonunda boyut kuculurse renderflex uyarisi veriyor onun kaldirilmasi
