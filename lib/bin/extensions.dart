import 'dart:convert';

import 'package:super_converter/bin/converter.dart';

/// Extension for SuperConverter class to be able to use it as a regular function
extension ConverterExtension on dynamic {
  /// Convert into any type
  T convert<T>({
    T? defaultValue,
  }) =>
      SuperConverter.convert(this, defaultValue: defaultValue);

  /// Convert into list
  List<T> convertToList<T>({
    List<T>? defaultValue,
    bool skipInvalid = false,
  }) =>
      SuperConverter.convertToList(
        this,
        defaultValue: defaultValue,
        skipInvalid: skipInvalid,
      );
}

extension MapConverter on Map {
  /// Extract value from map using dot notation
  extractValue(String key) {
    var subKeys = key.split('.');
    dynamic data = this;

    for (var key in subKeys) {
      if (data is String) data = jsonDecode(data);

      if (data is Map) {
        data = data[key];
      } else if (data is List) {
        data = data[key.convert<int>()];
      } else {
        return null;
      }
    }

    return data;
  }

  /// Convert into any type
  T from<T>(String key, {T? defaultValue}) {
    var data = extractValue(key);
    return SuperConverter.convert(data, defaultValue: defaultValue);
  }

  /// Convert into list
  List<T> fromList<T>(
    String key, {
    List<T>? defaultValue,
    bool returnNull = false,
    bool skipInvalid = false,
  }) {
    var data = extractValue(key);

    return SuperConverter.convertToList(
      data,
      defaultValue: defaultValue,
      skipInvalid: skipInvalid,
    );
  }
}
