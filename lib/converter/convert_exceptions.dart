/// helper class to wrap all exceptions thrown by [SuperConverter]
class SuperConvertorException {}

class InvalidFormatException implements SuperConvertorException {}

class UnKnownConverter implements SuperConvertorException {
  UnKnownConverter([this.type]);

  final Type? type;

  @override
  String toString() {
    return 'UnKnownConverter of $type try to register it with SuperConverter.registerConverters';
  }
}

class ConversionError implements SuperConvertorException {
  const ConversionError({required this.type, required this.data});

  final dynamic data;
  final Type? type;

  @override
  String toString() {
    return 'ConversionError[$type] cant handle $data';
  }
}

class ListConversionError extends ConversionError {
  const ListConversionError({required super.type, required super.data});

  @override
  String toString() =>
      'For List conversion use convertToList<X> instead of convert<List<X>>';
}
