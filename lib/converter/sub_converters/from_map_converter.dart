import 'dart:convert';

import 'package:super_converter/converter/converter.dart';

class FromMapConverter<T> extends SuperConverter<T> {
  FromMapConverter(this.handler);

  final T Function(Map<String, dynamic> value) handler;

  @override
  T? handle(value, {T? defaultValue}) {
    try {
      if (value == null || value == '' || value == {}) return defaultValue;

      if (value is String) value = jsonDecode(value);

      return handler(value);
    } catch (e) {
      if (defaultValue != null) return null;

      rethrow;
    }
  }
}
