// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class GeneralException extends AppException {
  GeneralException(String message) : super(message, 'GENERAL_ERROR');
}

// Network related exceptions
class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred'])
    : super(message, 'NETWORK_ERROR');
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException(String message, [this.statusCode])
    : super(message, 'SERVER_ERROR');
}

class TimeoutException extends AppException {
  TimeoutException([String message = 'Request timeout'])
    : super(message, 'TIMEOUT');
}

// Authentication exceptions
class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized access'])
    : super(message, 'UNAUTHORIZED');
}

class TokenExpiredException extends AppException {
  TokenExpiredException([
    String message = 'Session expired. Please login again',
  ]) : super(message, 'TOKEN_EXPIRED');
}

// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException(String message, [this.errors])
    : super(message, 'VALIDATION_ERROR');
}

// Resource exceptions
class NotFoundException extends AppException {
  NotFoundException([String message = 'Resource not found'])
    : super(message, 'NOT_FOUND');
}

// Business logic exceptions
class InsufficientStockException extends AppException {
  InsufficientStockException([String message = 'Insufficient stock available'])
    : super(message, 'INSUFFICIENT_STOCK');
}

class DuplicateException extends AppException {
  DuplicateException([String message = 'Resource already exists'])
    : super(message, 'DUPLICATE');
}

// Parse exceptions
class ParseException extends AppException {
  ParseException([String message = 'Failed to parse data'])
    : super(message, 'PARSE_ERROR');
}

// Cache exceptions
class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred'])
    : super(message, 'CACHE_ERROR');
}
