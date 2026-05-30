// lib/core/utils/dimension_label.dart

class DimensionLabel {
  DimensionLabel._();

  /// Returns the human-readable label for a dimension code (C/A/S/T/E/P).
  static String getLabel(String code) {
    switch (code.toUpperCase()) {
      case 'C':
        return 'Creative';
      case 'A':
        return 'Analytical';
      case 'S':
        return 'Social';
      case 'T':
        return 'Technical';
      case 'E':
        return 'Entrepreneurial';
      case 'P':
        return 'Physical';
      default:
        return 'Unknown';
    }
  }

  /// Returns a one-sentence explanation of what the dimension represents.
  static String getDescription(String code) {
    switch (code.toUpperCase()) {
      case 'C':
        return 'Design, expression, art, and storytelling.';
      case 'A':
        return 'Data, research, logic, and systems.';
      case 'S':
        return 'People, empathy, communication, and leadership.';
      case 'T':
        return 'Engineering, building, technology, and making.';
      case 'E':
        return 'Business, independence, risk, and scale.';
      case 'P':
        return 'Movement, hands-on work, outdoors, and sports.';
      default:
        return 'General interest dimension.';
    }
  }

  /// Returns an emoji representing the dimension.
  static String getEmoji(String code) {
    switch (code.toUpperCase()) {
      case 'C':
        return '🎨';
      case 'A':
        return '🔬';
      case 'S':
        return '🤝';
      case 'T':
        return '💻';
      case 'E':
        return '🚀';
      case 'P':
        return '💪';
      default:
        return '✨';
    }
  }
}
