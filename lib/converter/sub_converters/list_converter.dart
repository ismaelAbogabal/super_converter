import 'dart:convert';

import '../converter.dart';

class ListConverter<T> extends SuperConverter<List<T>> {
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
      } catch (e, stack) {
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
