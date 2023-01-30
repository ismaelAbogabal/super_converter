class InvalidFormatException implements Exception {}

class UnKnownConverter implements Exception {
  UnKnownConverter([this.type]);

  final Type? type;

  @override
  String toString() {
    return 'UnKnownConverter of $type';
  }
}

class ConversionError implements Exception {
  const ConversionError({required this.type, required this.data});

  final dynamic data;
  final Type? type;

  @override
  String toString() {
    return 'ConversionError[$type] cant handle $data';
  }
}
