import 'dart:convert';

import 'package:super_converter/bin/converter.dart';

/// Convert into list
/// If the value is not a list, it will be converted into a list with one item
/// If the value is a string, it will be converted into a list by jsonDecode
class ListConverter<T> {
  @override
  List<T> handle(
    value, {
    List<T>? defaultValue,
    bool skipInvalid = false,
  }) {
    if (value == null || value == [] || value == '') {
      if (defaultValue != null) return defaultValue;
    }

    if (value is String && value.isNotEmpty) value = jsonDecode(value);

    if (value is! List) {
      value = [value];
    }

    List<T> response = [];

    for (var e in value) {
      try {
        response.add(SuperConverter.convert<T>(e));
      } catch (e) {
        if (skipInvalid) {
          // print(
          //   '[CustomConverter][ListConverter<$T>] '
          //   'skip invalid item ${value.toString().padRight(100).substring(0, 100)}',
          // );
        } else {
          rethrow;
        }
      }
    }

    return response;
  }
}
