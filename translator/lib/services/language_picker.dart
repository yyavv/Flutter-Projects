import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'language.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title: Text('Language Picker'),
        ),
        body: Center(
          child: LanguageSelection(),
        ),
      ),
    );
  }
}

class LanguageSelection extends StatefulWidget {
  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  int _selectedStart = 0;
  int _selectedDest = 1;

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
    return Row(
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
    );
  }
}

class LanguagePicker extends StatefulWidget {
  final int selectedLanguage;
  final ValueChanged<int> onSelectedItemChanged;

  const LanguagePicker({
    super.key,
    required this.selectedLanguage,
    required this.onSelectedItemChanged,
  });

  @override
  _LanguagePickerState createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  late int _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
  }

  @override
  void didUpdateWidget(LanguagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLanguage != widget.selectedLanguage) {
      _selectedLanguage = widget.selectedLanguage;
    }
  }

  void _showDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(
              initialItem: _selectedLanguage,
            ),
            onSelectedItemChanged: (int selectedItem) {
              setState(() {
                _selectedLanguage = selectedItem;
              });
              widget.onSelectedItemChanged(selectedItem);
            },
            children: List<Widget>.generate(Language.names.length, (int index) {
              return Center(child: Text(Language.getNameByIndex(index)));
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showDialog(context),
      child: Text(
        Language.getNameByIndex(_selectedLanguage),
        style: const TextStyle(
          fontSize: 22.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
