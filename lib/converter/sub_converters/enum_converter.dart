import 'package:super_converter/converter/convert_exceptions.dart';
import 'package:super_converter/converter/converter.dart';

class EnumConverter<T> extends SuperConverter<T> {
  EnumConverter(
    this.values, {
    this.toName = _convertName,
    this.defaultItem,
  });

  final List<T> values;
  final String Function(dynamic value) toName;
  final T? defaultItem;

  static String _convertName(dynamic v) {
    return v?.toString().toLowerCase().split('.').last ?? '';
  }

  @override
  T handle(value, {T? defaultValue}) {
    try {
      for (var item in values) {
        if (toName(item) == toName(value)) {
          return item;
        }
      }

      if (defaultValue != null) return defaultValue;

      throw ConversionError(type: T, data: value);

      // return item;
    } catch (e, s) {
      if (defaultValue != null) return defaultValue;

      rethrow;
    }
  }
}
