import 'package:super_converter/bin/converter.dart';

/// Convert into boolean
class BoolConverter extends SuperConverterHandler<bool> {
  @override
  Child? handle<Child extends bool>(value, {bool? defaultValue}) {
    return [true, 'true', 1, '1'].contains(value) as Child?;
  }
}

class StringConverter extends SuperConverterHandler<String> {
  @override
  Child? handle<Child extends String>(value, {String? defaultValue}) {
    if (value == null) return defaultValue as Child?;

    return value.toString() as Child?;
  }
}

/// Convert into int
class IntConverter extends SuperConverterHandler<int> {
  @override
  Child? handle<Child extends int>(value, {int? defaultValue}) {
    return int.tryParse(value.toString()) as Child?;
  }
}

/// Convert into double
class DoubleConverter extends SuperConverterHandler<num> {
  @override
  Child? handle<Child extends num>(value, {num? defaultValue}) {
    return num.tryParse(value?.toString() ?? '')?.toDouble() as Child?;
  }
}

/// Convert into datetime
class DateTimeConverter extends SuperConverterHandler<DateTime> {
  @override
  Child? handle<Child extends DateTime>(value, {DateTime? defaultValue}) {
    if (value is! String) value = value.toString();

    final intValue = IntConverter().handle(value);

    if (intValue != null) {
      return DateTime.fromMillisecondsSinceEpoch(intValue * 1000) as Child?;
    }

    for (var f in SuperConverter.dateFormats) {
      try {
        return f.parse(value) as Child?;
      } catch (e) {
        //not available
      }
    }

    try {
      return DateTime.parse(value) as Child?;
    } catch (e) {
      return defaultValue as Child?;
    }
  }
}
/*
class ConverterBuilder<T> extends SuperConverterHandler<T> {
  ConverterBuilder(this.handler);

  final T? Function(dynamic value, {T? defaultValue}) handler;

  @override
  T? handle(value, {T? defaultValue}) =>
      handler(value, defaultValue: defaultValue);
}*/
