# Text File Translator App

A Flutter application that allows users to select `.txt` or `.srt` files, process the file content by adding markers to maintain structure, translate the content using a translation service (like Gemini API), and then save the translated content back to a new file with the same extension.

## Features

1. **File Selection**: Users can select text files (`.txt` and `.srt` formats) from their local system.
2. **Text Modification**: Adds "@" marks to the end of each line in the selected file to preserve the structure during translation.
3. **Translation**: Integrates with a translation service (e.g., Gemini API) to translate the modified text.
4. **File Saving**: Saves the translated text back to a new file with the prefix "translated-" while maintaining the original file extension.
5. **Marker Removal**: After translation, removes the "@" marks from the translated text before saving.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter SDK**: Install the Flutter SDK on your machine. Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) for your platform.
- **Dart SDK**: Included with the Flutter installation.
- **API Key**: You need an API key for the translation service (like Gemini API). Obtain it by registering on their platform.
- **File Picker Package**: This application uses `file_picker` package to select files.
- **Flutter Dotenv Package**: Used for environment variable management.

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/text-file-translator-app.git
cd text-file-translator-app
