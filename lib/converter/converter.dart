import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

import 'convert_exceptions.dart';
import 'sub_converters/base_converters.dart';
import 'sub_converters/list_converter.dart';

typedef NullAble<T> = T?;

class _TypeHelper<T> {}

abstract class SuperConverter<T> {
  static final List<SuperConverter> _converters = [
    BoolConverter(),
    StringConverter(),
    IntConverter(),
    DoubleConverter(),
    DateTimeConverter(),
    ListConverter(),
  ];

  static final List<DateFormat> dateFormats = [
    DateFormat('yyyy-MM-dd hh:mm a'),
    DateFormat('yyyy-MM-dd HH:mm'),
    DateFormat('yyyy-MM-dd'),
    DateFormat('yyyy/MM/dd hh:mm a'),
    DateFormat('yyyy/MM/dd HH:mm'),
    DateFormat('yyyy/MM/dd'),
  ];

  /// date formats used to convert string into dates
  static registerDateFormats(List<DateFormat> formats) {
    dateFormats.insertAll(0, formats);
  }

  /// register multi converter into the list
  static registerConverters(List<SuperConverter> converters) {
    _converters.insertAll(0, converters);
  }

  /// convert in case of single item
  static T convert<T>(dynamic value, {T? defaultValue}) {
    if (value is T) return value;

    if (isSubType<List, T>()) throw ListConversionError(type: T, data: value);

    for (var converter in _converters) {
      if (converter.canHandle<T>()) {
        try {
          return converter.handle(value, defaultValue: defaultValue) ??
              defaultValue;
        } catch (e) {
          if (defaultValue is T) return defaultValue;

          throw ConversionError(type: converter.runtimeType, data: value);
        }
      }
    }

    /// try to register your class by using [registerConverters] method
    /// For Enums you can use [EnumConverter]
    /// For Classes you can use [FromMapConverter]
    throw UnKnownConverter(T);
  }

  static List<O> convertToList<O>(
    dynamic value, {
    /// return default value in case of there are no item
    List<O>? defaultValue,

    /// skip invalid items if item got validation error
    bool skipInvalid = false,
  }) {
    return ListConverter<O>().handle(
      value,
      defaultValue: defaultValue,
      skipInvalid: skipInvalid,
    );
  }

  T? handle(dynamic value, {T? defaultValue});

  bool canHandle<Child>() => isSubType<T, Child>();

  static bool isSubType<Super, Child>() =>
      _TypeHelper<Child>() is _TypeHelper<Super?> ||
      _TypeHelper<Child>() is _TypeHelper<Super> ||
      _TypeHelper<Child>() is _TypeHelper<FutureOr<Super>> ||
      _TypeHelper<Child>() is _TypeHelper<FutureOr<Super?>>;
}

extension ConverterExtension on dynamic {
  T convert<T>({
    T? defaultValue,
  }) =>
      SuperConverter.convert(this, defaultValue: defaultValue);

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

  T from<T>(String key, {T? defaultValue}) {
    var data = extractValue(key);
    return SuperConverter.convert(data, defaultValue: defaultValue);
  }

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
