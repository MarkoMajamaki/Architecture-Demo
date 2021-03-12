import 'package:uuid/uuid.dart';

///
/// Class that emulates as closely as possible the C# Guid type.
///
/// Original source: https://github.com/rocket-libs/flutter_guid
/// Done own version because library was not null safe ready!
///
class Guid {
  // The Guid whose value is the default sequence of characters that represent a 'zero-value' UUID in .Net "00000000-0000-0000-0000-000000000000"
  static Guid get defaultValue => new Guid(_defaultGuid);

  // Default empty guid
  static const String _defaultGuid = "00000000-0000-0000-0000-000000000000";

  // Valid uuid versions
  static Map _uuid = {
    '3': new RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$'),
    '4': new RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
    '5': new RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
    'all': new RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$')
  };

  // Guid value as string
  String? _value;

  ///
  /// Constructor, expects a valid UUID and will throw an exception if the value provided is invalid.
  ///
  Guid(String v) {
    _failIfNotValidGuid(v);
    _value = v;
  }

  ///
  /// Generates a new v4 UUID and returns a GUID instance with the new UUID.
  ///
  static Guid get newGuid {
    return new Guid(Uuid().v4());
  }

  ///
  /// Checks whether a value is a valid Guid. Returns false if 'guid' is null or
  /// has an invalid value Returns true if guid is valid
  ///
  static bool isValid(Guid? guid) {
    if (guid == null) {
      return false;
    } else {
      return isUUID(guid.value);
    }
  }

  _failIfNotValidGuid(String? v) {
    if (v == null || v.isEmpty) {
      v = _defaultGuid;
    }
    final isInvalid = isUUID(v) == false;
    if (isInvalid) {
      throw new GuidError("Value '$v' is not a valid UUID");
    }
  }

  ///
  /// check if the string is a UUID (version 3, 4 or 5).
  ///
  static bool isUUID(String str, [version]) {
    if (version == null) {
      version = 'all';
    } else {
      version = version.toString();
    }

    RegExp pat = _uuid[version];
    return (pat.hasMatch(str.toUpperCase()));
  }

  ///
  /// Gets the UUID value contained by the Guid object as a string.
  ///
  String get value {
    if (_value == null || _value!.isEmpty) {
      return _defaultGuid;
    } else {
      return _value!;
    }
  }

  ///
  /// Performs a case insensitive comparison on the UUIDs contained in two Guid
  /// objects. Comparison is by value and not by reference.
  ///
  bool operator ==(other) {
    return this.value.toLowerCase() == other.toString().toLowerCase();
  }

  ///
  /// Returns the hashCode.
  ///
  @override
  int get hashCode {
    return super.hashCode;
  }

  ///
  /// Gets the UUID value contained by the Guid object as a string.
  ///
  @override
  String toString() {
    return value;
  }
}

class GuidError extends Error {
  final String message;

  GuidError(this.message);
}
