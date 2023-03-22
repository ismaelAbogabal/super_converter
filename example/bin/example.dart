import 'package:super_converter/converter/converter.dart';
import 'package:super_converter/converter/sub_converters/enum_converter.dart';
import 'package:super_converter/converter/sub_converters/from_map_converter.dart';

void main(List<String> arguments) {
  int intValue = '5'.convert(); // 6
  int intValue2 = 5.convert(); // 5
  int intValue3 = '  5  '.convert(); // 5

  /// Supported date formats by default
  /// 'MM/dd/yyyy HH:mm',
  /// 'MM/dd/yyyy hh:mm a',
  /// 'MM/dd/yyyy',
  /// 'yyyy-MM-dd hh:mm a',
  /// 'yyyy-MM-dd HH:mm',
  /// 'yyyy-MM-dd',
  ///

  /// to register more formats
  // SuperConverter.registerDateFormats([]);
  DateTime date = '2020-11-24'.convert();
  DateTime date2 = DateTime.now().toUtc().convert();

  bool boolean = 'true'.convert();
  bool boolean2 = 1.convert();
  bool boolean3 = true.convert();
  bool boolean4 = '1'.convert();
  bool boolean5 = ''.convert();
  bool boolean6 = false.convert();
  bool boolean7 = 'otherwise'.convert();

  /// enum conversions
  // enum Gender { male, female, otherwise }

  SuperConverter.registerConverters([EnumConverter<Gender>(Gender.values)]);
  Gender gender = 'male'.convert();
  Gender gender2 = 'female'.convert();
  Gender gender3 = 'OTHERWISE'.convert();
  Gender? genderInvalid = 'c'.convert();
  Gender? genderWithNoConverter = Gender.male.convert();

  SuperConverter.registerConverters(
      [FromMapConverter<UserDto>(UserDto.fromMap)]);
  String apiResponse =
      '{"id":1,"profile":{"name":"ismael","gender":"male"},"email":"ismael@gmail.com"}';
  UserDto user = apiResponse.convert();

  print(apiResponse);
}

enum Gender { male, female, otherwise }

class UserDto {
  final int id;
  final String name;
  final String email;
  final Gender gender;

  UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: map.from('id'),
      name: map.from('profile.name'),
      gender: map.from('profile.gender'),
      email: map.from('email'),
    );
  }
}
