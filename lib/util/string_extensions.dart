extension StringExtensions on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String firstLetter({String fallback = '?'}) {
    if (isEmpty) return fallback;
    return this[0].toUpperCase();
  }
}
