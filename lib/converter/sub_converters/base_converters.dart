import '../converter.dart';

/// Convert into boolean
class BoolConverter extends SuperConverter<bool> {
  @override
  bool? handle(value, {bool? defaultValue}) {
    return [true, 'true', 1, '1'].contains(value);
  }
}

/// Convert into int
class IntConverter extends SuperConverter<int> {
  @override
  int? handle(value, {int? defaultValue}) {
    return int.tryParse(value.toString());
  }
}

/// Convert into double
class DoubleConverter extends SuperConverter<num> {
  @override
  num? handle(value, {num? defaultValue}) {
    return num.tryParse(value?.toString() ?? '')?.toDouble();
  }
}

/// Convert into string
class StringConverter extends SuperConverter<String> {
  @override
  String? handle(value, {String? defaultValue}) {
    if (value == null) return defaultValue;

    return value.toString();
  }
}

/// Convert into datetime
class DateTimeConverter extends SuperConverter<DateTime> {
  @override
  DateTime? handle(value, {DateTime? defaultValue}) {
    if (value is! String) value = value.toString();

    final intValue = IntConverter().handle(value);

    if (intValue != null) {
      return DateTime.fromMillisecondsSinceEpoch(intValue * 1000);
    }

    for (var f in SuperConverter.dateFormats) {
      try {
        return f.parse(value);
      } catch (e) {
        //not available
      }
    }

    try {
      return DateTime.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }
}

class ConverterBuilder<T> extends SuperConverter<T> {
  ConverterBuilder(this.handler);

  final T? Function(dynamic value, {T? defaultValue}) handler;

  @override
  T? handle(value, {T? defaultValue}) =>
      handler(value, defaultValue: defaultValue);
}
