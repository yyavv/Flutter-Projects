import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/services/language_picker.dart';
import 'package:typewritertext/typewritertext.dart';

import '../services/language.dart';
import '../services/translate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

//TODO: add favorites and recent to the app bar
//Todo: new text font

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String? _translatedText;
  int _selectedStart = 0;
  int _selectedDest = 1;

  void _translateText() async {
    String text = '';

    if (_controller.text.isNotEmpty) {
      text = await Translator(
              text: _controller.text,
              start: Language.getNameByIndex(_selectedStart),
              dest: Language.getNameByIndex(_selectedDest))
          .generateText();
    }

    setState(() {
      if (_controller.text.isNotEmpty) {
        _translatedText = text;
      }
    });
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

  void _pasteText() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null &&
        clipboardData.text != null &&
        clipboardData.text!.isNotEmpty) {
      setState(() {
        _controller.text = clipboardData.text!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clipboard is empty'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff372549),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1A1423),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 7,
                  maxLength: 300,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Text",
                    hintStyle: const TextStyle(color: Colors.white),
                    fillColor: Colors.transparent,
                    filled: true,
                    suffixIcon: GestureDetector(
                      onTap: _pasteText,
                      child: const Icon(Icons.paste, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _translateText();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('Translate'),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1A1423),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Translated Text:',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 17,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.white),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: _translatedText ?? ''));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to clipboard'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    //const SizedBox(height: 10),
                    Container(
                      height: 200, // Adjust the height as needed
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TypeWriter.text(
                            _translatedText ?? ' ',
                            duration: const Duration(milliseconds: 50),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            // Key is assigned based on the text
                            key: ValueKey(_translatedText),
                          ),
                        ),
                      ),
                    )
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
