class Language {
  static final List<String> names = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Turkish',
    'Arabic',
    'Bengali',
    'Chinese (Mandarin)',
    'Dutch',
    'Hindi',
    'Italian',
    'Japanese',
    'Javanese',
    'Korean',
    'Persian (Farsi)',
    'Polish',
    'Portuguese',
    'Russian',
  ];

  static String getNameByIndex(int index) {
    if (index >= 0 && index < names.length) {
      return names[index];
    } else {
      return 'Unknown';
    }
  }
}
