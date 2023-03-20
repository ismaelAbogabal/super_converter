<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

I always suffer from the way i have to convert the backend response into a flutter classes
that's why i created this package to help me easily convert anything into anything
as long as it has the required data to be converter it should be done automatically

## Features

- Convert anything into anything
- Basic types conversion out of the box (dart base types)
- User specific class can easily add into convertible types throw [FromMapConverter]
- Enums are also supported out of the box
- Can extract certain key from the map and convert it
- Support nested keys from the map
- and much more features

## Getting started

1. Added it into your pubspec.yaml file

```shell
flutter pub add super_converter
```

2. Register you owen classes (no need for this step since the version 1.0.0)
2.1 Enums are auto detected
2.2 Classes are auto detected if they have a factory/constructor called fromMap

```dart
SuperConverter.registerConverters([
// enum Converters using 
// EnumConverter<Enum>(Enum.values);

// classes throw 
// FromMapConverter<UserDto>(UserDto.fromMap)
]);
```

3. Convert

```dart
UserDto user = apiResponse.convert(); // UserDto()
UserDto? userNullable = apiResponse.convert(); // UserDto()
final userExplicitly = apiResponse.convert<UserDto?>(); // UserDto()
```

## Usage
1. Simple types conversion

### Integers

```dart
int intValue = '5'.convert(); // 5
int intValue2 = 5.convert(); // 5
int intValue3 = '  5  '.convert(); // 5
```

### Dates
Supported date formats by default
- 'MM/dd/yyyy HH:mm',
- 'MM/dd/yyyy hh:mm a',
- 'MM/dd/yyyy',
- 'yyyy-MM-dd hh:mm a',
- 'yyyy-MM-dd HH:mm',
- 'yyyy-MM-dd',

```dart
// Register dates formats if needed
SuperConverter.registerDateFormats([]);

// convert it
DateTime date = '2020-11-24'.convert(); // DateTime()

DateTime date2 = DateTime.now().toUtc().convert(); // DateTime()
```

### Enums

gender.dart

```dart
enum Gender { male, female, otherwise }
```

On main.dart

```dart
SuperConverter.registerConverters([EnumConverter<Gender>(Gender.values)]);
```

Usage

```dart
Gender gender = 'male'.convert(); // Gender.male;
Gender gender2 = 'female'.convert(); // Gender.female;
Gender gender3 = 'OTHERWISE'.convert(); // Gender.otherwise;
Gender? genderInvalid = 'c'.convert(); // null;
```

### Classes convert
#### Register
```dart
SuperConverter.registerConverters([FromMapConverter<UserDto>(UserDto.fromMap)]);
```
#### Usage
```dart
 String apiResponse = '{"id":1,"profile":{"name":"ismael","gender":"male"},"email":"ismael@gmail.com"}';
  UserDto user = apiResponse.convert(); // UserDto()
```

### Map Utils
extract data from map value and convert it 

```dart
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

```


## Additional information

All the code will be found in the example project
