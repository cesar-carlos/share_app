abstract class AppFailure implements Exception {
  final String message;

  const AppFailure(this.message);

  @override
  String toString() => message;
}

class ShareFailure extends AppFailure {
  const ShareFailure(super.message);

  factory ShareFailure.error(Object error) {
    return ShareFailure('Error sharing files: $error');
  }
}

class DecodeFailure extends AppFailure {
  const DecodeFailure(super.message);

  factory DecodeFailure.base64Decode() {
    return const DecodeFailure('Failed to decode base64 arguments');
  }

  factory DecodeFailure.jsonParse() {
    return const DecodeFailure('Failed to parse JSON data');
  }

  factory DecodeFailure.invalidFormat() {
    return const DecodeFailure('Invalid argument format');
  }

  factory DecodeFailure.error(Object error) {
    return DecodeFailure('Error decoding args: $error');
  }
}

class JsonParseFailure extends AppFailure {
  const JsonParseFailure(super.message);

  factory JsonParseFailure.missingField(String field) {
    return JsonParseFailure('Missing required field: $field');
  }

  factory JsonParseFailure.invalidType(String field, String expectedType) {
    return JsonParseFailure('Invalid type for $field, expected $expectedType');
  }

  factory JsonParseFailure.error(Object error) {
    return JsonParseFailure('Error parsing JSON: $error');
  }
}
