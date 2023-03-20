import 'dart:async';

import 'package:intl/intl.dart';

import '../basic_converters/ListConverter.dart';
import '../basic_converters/enum_converter.dart';
import '../basic_converters/from_map_converter.dart';
import '../basic_converters/simple_converters.dart';
import 'convert_exceptions.dart';

/// Detect if the type [Child] is a sub type of [T]
class _TypeHelper<T> {
  static bool isSubType<Super, Child>() =>
      _TypeHelper<Child>() is _TypeHelper<Super?> ||
      _TypeHelper<Child>() is _TypeHelper<Super> ||
      _TypeHelper<Child>() is _TypeHelper<FutureOr<Super>> ||
      _TypeHelper<Child>() is _TypeHelper<FutureOr<Super?>>;
}

/// The base class for all converters
abstract class SuperConverterHandler<T> {
  T? handle<Child extends T>(value, {Child? defaultValue});

  /// check the current type [T] is a sub type of [Child]
  bool canHandle<Child>() => _TypeHelper.isSubType<T, Child>();

  /// check the current converter can handle the type conversion of [Child]
  bool isSameType<Child>(value) => _TypeHelper.isSubType<T, Child>();
}

class SuperConverter {
  /// list of all converters used to convert data
  static final List<SuperConverterHandler> _converters = [
    BoolConverter(),
    IntConverter(),
    DoubleConverter(),
    StringConverter(),
    DateTimeConverter(),
    EnumAutoConverter(),
    FromMapAutoConverter(),
  ];

  /// date formats used to convert string into dates
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
    _converters.insertAll(0, _converters);
  }

  ///- here is where all the magic happens
  ///- use the converters to convert the data into the type [T]
  static T convert<T>(value, {T? defaultValue}) {
    if (_TypeHelper.isSubType<List, T>()) {
      throw ListConversionError(type: T, data: value);
    }

    for (var c in _converters) {
      if (c.canHandle<T>()) {
        try {
          return c.handle<T>(value, defaultValue: defaultValue) as T;
        } catch (e) {
          if (defaultValue is T) return defaultValue;

          throw ConversionError(type: T, data: value);
        }
      }
    }

    if (defaultValue is T) return defaultValue;

    throw UnKnownConverter(T);
  }

  ///- here is where all the magic happens
  ///- converting the [value] into a list of type [T]
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
}
