import 'package:super_converter/converter/convert_exceptions.dart';
import 'package:super_converter/converter/converter.dart';
import 'package:super_converter/converter/sub_converters/from_map_converter.dart';
import 'package:test/test.dart';

class Test {
  final int a;
  final String b;
  final bool c;

  Test({required this.a, required this.b, required this.c});

  Test.fromMap(Map<String, dynamic> map)
      : a = map.from('a'),
        b = map.from('b'),
        c = map.from('c');
}

class Test2 {
  final Test t;

  Test2({required this.t});

  Test2.fromMap(Map<String, dynamic> map) : t = map.from('t');
}

void main() {
  group('Conversion test', () {
    SuperConverter.registerConverters([
      FromMapConverter<Test>(Test.fromMap),
      FromMapConverter<Test2>(Test2.fromMap),
    ]);
    test('String test', () {
      expect('1'.convert<String>(), '1');
      expect(1.convert<String>(), '1');
      expect(true.convert<String>(), 'true');

      expect(() => null.convert<String>(), throwsA(isA<ConversionError>()));
    });

    test('numbers convertor', () {
      expect('1'.convert<int>(), 1);
      expect(1.convert<int>(), 1);

      expect(() => 1.5.convert<int>(), throwsA(isA<ConversionError>()));
      expect(() => null.convert<int>(), throwsA(isA<ConversionError>()));
      expect(() => true.convert<int>(), throwsA(isA<ConversionError>()));
    });

    test('double convertor', () {
      expect('1'.convert<double>(), 1.0);
      expect(1.convert<double>(), 1.0);
      expect(1.5.convert<double>(), 1.5);

      expect(() => null.convert<double>(), throwsA(isA<ConversionError>()));
      expect(() => true.convert<double>(), throwsA(isA<ConversionError>()));
    });

    test('num converter', () {
      expect('1'.convert<num>(), 1);
      expect(1.convert<num>(), 1);
      expect(1.5.convert<num>(), 1.5);

      expect(() => null.convert<num>(), throwsA(isA<ConversionError>()));
      expect(() => true.convert<num>(), throwsA(isA<ConversionError>()));
    });

    test('Date converters', () {
      expect(3526654.convert<DateTime>(), isA<DateTime>());

      expect('3526654'.convert<DateTime>(), isA<DateTime>());

      expect('2020/1/3'.convert<DateTime>(), DateTime(2020, 1, 3));
      expect('2020-1-3'.convert<DateTime>(), DateTime(2020, 1, 3));
    });

    test('List converter', () {
      expect(1.convertToList<int>(), [1]);
      expect(1.convertToList<String>(), ['1']);
      expect('1'.convertToList<int>(), [1]);
      expect('0.2'.convertToList<num>(), [.2]);

      expect(() => ['1'].convert<List<int>>(),
          throwsA(isA<ListConversionError>()));

      expect(['1'].convertToList<int>(), isA<List<int>>());
    });

    test('Unknown converter', () {
      expect(() => '1'.convert<Test>(), throwsA(isA<UnKnownConverter>()));
    });

    test('Custom conversion ', () {
      final Test test =
          '{"a": 1,"b" : "String value", "c" : true}'.convert<Test>();

      expect(test, isA<Test>());
    });

    test('Sub converter error ', () {
      /// throw unknown converter error Test isnot registered
      final test = () => '{}'.convert<Test2>();

      expect(test, throwsA(isA<UnKnownConverter>()));
    });
  });
}
