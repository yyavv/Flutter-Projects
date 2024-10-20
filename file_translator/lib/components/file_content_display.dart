import 'package:flutter/material.dart';

class FileContentDisplay extends StatefulWidget {
  final String fileContentLeft;
  final String initialFileContentRight;
  final ValueChanged<String> onTextChanged;
  final String l1;
  final String l2;

  const FileContentDisplay({
    Key? key,
    required this.fileContentLeft,
    required this.initialFileContentRight,
    required this.onTextChanged,
    required this.l1,
    required this.l2,
  }) : super(key: key);

  @override
  _FileContentDisplayState createState() => _FileContentDisplayState();
}

class _FileContentDisplayState extends State<FileContentDisplay> {
  late TextEditingController _rightTextController;

  @override
  void initState() {
    super.initState();
    _rightTextController =
        TextEditingController(text: widget.initialFileContentRight);

    // Listen for changes in the TextField
    _rightTextController.addListener(() {
      widget.onTextChanged(
          _rightTextController.text); // Call the callback with the current text
    });
  }

  @override
  void dispose() {
    _rightTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.l1, style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_right_alt, size: 25),
            Text(widget.l2, style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
        SizedBox(height: 5),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            height: MediaQuery.of(context).size.height *
                0.4, // Set a fixed height for the container
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Text(
                            widget.fileContentLeft.isEmpty
                                ? 'No content to display'
                                : widget.fileContentLeft,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _rightTextController,
                          style: const TextStyle(fontSize: 14),
                          maxLines: null, // Allows for multiple lines
                          decoration: InputDecoration(
                            hintText: 'Edit content here',
                            border: InputBorder.none, // Remove the underline
                            enabledBorder: InputBorder
                                .none, // Remove the underline when enabled
                            focusedBorder: InputBorder
                                .none, // Remove the underline when focused
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
