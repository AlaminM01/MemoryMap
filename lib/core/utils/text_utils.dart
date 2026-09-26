import '../constants/app_constants.dart';

class TextUtils {
  /// Calculates estimated reading time in minutes
  static int calculateReadingTime(String content) {
    if (content.trim().isEmpty) return 1;
    final words = content.trim().split(RegExp(r'\s+')).length;
    final minutes = (words / AppConstants.wordsPerMinuteReadingSpeed).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  /// Calculates word count
  static int countWords(String content) {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  /// Strips markdown characters for clean preview
  static String stripMarkdown(String markdown) {
    var text = markdown;
    // Remove headers
    text = text.replaceAll(RegExp(r'^#+\s+', multiLine: true), '');
    // Remove bold and italics
    text = text.replaceAll(RegExp(r'[*_]{1,3}'), '');
    // Remove inline code and code blocks
    text = text.replaceAll(RegExp(r'`{1,3}[^`]*`{1,3}'), '');
    // Remove blockquotes
    text = text.replaceAll(RegExp(r'^>\s+', multiLine: true), '');
    // Remove bullet points / lists
    text = text.replaceAll(RegExp(r'^[-*+]\s+', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '');
    // Trim extra spaces
    return text.replaceAll(RegExp(r'\n+'), ' ').trim();
  }

  /// Gets clean short preview
  static String getPreview(String content, [int maxChars = 140]) {
    final clean = stripMarkdown(content);
    if (clean.length <= maxChars) return clean;
    return '${clean.substring(0, maxChars).trimRight()}...';
  }
}
