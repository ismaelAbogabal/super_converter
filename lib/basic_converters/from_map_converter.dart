import 'dart:convert';
import 'dart:mirrors';

import 'package:super_converter/bin/converter.dart';

/// Convert into class
/// Auto detect class by checking if the class has a static method named `fromMap`
class FromMapAutoConverter extends SuperConverterHandler<Object> {
  @override
  Child? handle<Child extends Object>(value, {Child? defaultValue}) {
    if (value is String) value = jsonDecode(value);

    final classMirror = reflectClass(Child);

    final reflectee = classMirror.newInstance(const Symbol('fromMap'), [
      value,
    ]).reflectee;

    return reflectee;
  }

  @override
  bool canHandle<Child>() {
    final classMirror = reflectClass(Child);

    return classMirror.declarations[Symbol('$Child.fromMap')] != null;
  }
}
