class Errorexceptios implements Exception {
  final prefix;
  final message;
  final errorCode;

  Errorexceptios([this.prefix, this.message, this.errorCode]);

  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends Errorexceptios {
  final message;

  FetchDataException([this.message])
      : super("Error During Communication: ", message, 500);
}

class FetchDataErrorException extends Errorexceptios {
  final message;

  FetchDataErrorException([this.message])
      : super("Something went wrong please try again: ", message, 404);
}

class BadRequestException extends Errorexceptios {
  final message;

  BadRequestException([this.message])
      : super("Invalid Request: ", message, 404);
}

class UnauthorisedException extends Errorexceptios {
  final message;

  UnauthorisedException([this.message]) : super("Unauthorised: ", message, 401);
}

class InvalidInputException extends Errorexceptios {
  final message;

  InvalidInputException([this.message]) : super("Invalid Input: ", message);
}
