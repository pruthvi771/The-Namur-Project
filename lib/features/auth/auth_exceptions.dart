//sign-in exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//sign-up exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}

class InvalidOTPAuthException implements Exception {}

class ExpiredOTPAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

class OperationNotAllowedAuthException implements Exception {}

class InvalidVerificationCodeAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

class AccountExistsWithDifferentCredentialAuthException implements Exception {}
