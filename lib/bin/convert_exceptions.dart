/// This exception is thrown when the converter is not found
class UnKnownConverter implements Exception {
  UnKnownConverter([this.type]);

  final Type? type;

  @override
  String toString() {
    return 'UnKnownConverter of $type try to register it with SuperConverter.registerConverters';
  }
}

/// This exception is thrown when the converter failed to convert the data
class ConversionError implements Exception {
  const ConversionError({
    required this.type,
    required this.data,
  });

  final dynamic data;
  final Type? type;

  @override
  String toString() {
    return 'ConversionError[$type] cant handle $data';
  }
}

/// This exception is thrown when user try to convert list using convert instead of convertToList
class ListConversionError extends ConversionError {
  const ListConversionError({required super.type, required super.data});

  @override
  String toString() =>
      'For List conversion use convertToList<X> instead of convert<List<X>>';
}
