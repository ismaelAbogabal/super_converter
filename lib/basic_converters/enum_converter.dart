import 'dart:mirrors';

import 'package:super_converter/bin/converter.dart';

/// Convert into enum
/// Auto detect enum by checking if the class is enum
/// If you want to use this converter, you must add this converter to the list of converters
class EnumAutoConverter<T> extends SuperConverterHandler<T> {
  static String _convertName(dynamic v) {
    return v?.toString().toLowerCase().split('.').last ?? '';
  }

  @override
  Child? handle<Child extends T>(value, {defaultValue}) {
    final childClass = reflectClass(Child);

    final values = childClass.getField(#values).reflectee as List<Child>;

    return values.firstWhere((e) => _convertName(e) == _convertName(value));
  }

  @override
  bool canHandle<Child>() {
    final childClass = reflectClass(Child);

    return childClass.isEnum;
  }
}
