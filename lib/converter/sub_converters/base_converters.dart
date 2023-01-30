import '../converter.dart';

/// active value 1,'1', true, 'true'
class BoolConverter extends SuperConverter<bool> {
  @override
  bool? handle(value, {bool? defaultValue}) {
    return [true, 'true', 1, '1'].contains(value);
  }
}

class IntConverter extends SuperConverter<int> {
  @override
  int? handle(value, {int? defaultValue}) {
    return int.tryParse(value.toString());
  }
}

class DoubleConverter extends SuperConverter<double> {
  @override
  double? handle(value, {double? defaultValue}) {
    return double.tryParse(value?.toString() ?? '');
  }
}

class StringConverter extends SuperConverter<String> {
  @override
  String? handle(value, {String? defaultValue}) {
    if (value == null) return defaultValue;

    return value.toString();
  }
}

class DateTimeConverter extends SuperConverter<DateTime> {
  @override
  DateTime? handle(value, {DateTime? defaultValue}) {
    if (value is! String) value = value.toString();

    if (int.tryParse(value) != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(value) * 1000);
    }

    for (var f in SuperConverter.dateFormats) {
      try {
        return f.parse(value);
      } catch (e) {}
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
