import 'package:dio/dio.dart';
import 'exceptions.dart';

class ErrorHandler {
  static AppException handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is AppException) {
      return error;
    } else {
      return GeneralException(
        'An unexpected error occurred: ${error.toString()}',
      );
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Connection timeout. Please try again.');

      case DioExceptionType.badResponse:
        return _handleStatusCode(error);

      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled');

      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network.',
        );

      case DioExceptionType.unknown:
        return NetworkException('Network error. Please try again.');

      default:
        return NetworkException('An unexpected network error occurred');
    }
  }

  static AppException _handleStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'An error occurred';
    if (data is Map && data.containsKey('error')) {
      message = data['error'].toString();
    } else if (data is Map && data.containsKey('message')) {
      message = data['message'].toString();
    }

    switch (statusCode) {
      case 400:
        if (message.toLowerCase().contains('insufficient stock')) {
          return InsufficientStockException(message);
        }
        return ValidationException(message);

      case 401:
        if (message.toLowerCase().contains('expired')) {
          return TokenExpiredException(message);
        }
        return UnauthorizedException(message);

      case 403:
        return UnauthorizedException('Access forbidden');

      case 404:
        return NotFoundException(message);

      case 409:
        return DuplicateException(message);

      case 500:
      case 502:
      case 503:
        return ServerException(
          'Server error. Please try again later.',
          statusCode,
        );

      default:
        return ServerException(message, statusCode);
    }
  }

  static String getUserFriendlyMessage(AppException exception) {
    if (exception is NetworkException) {
      return 'Please check your internet connection and try again.';
    } else if (exception is TimeoutException) {
      return 'The request took too long. Please try again.';
    } else if (exception is UnauthorizedException) {
      return 'Please login to continue.';
    } else if (exception is TokenExpiredException) {
      return 'Your session has expired. Please login again.';
    } else if (exception is NotFoundException) {
      return 'The requested item was not found.';
    } else if (exception is InsufficientStockException) {
      return exception.message;
    } else if (exception is ValidationException) {
      return exception.message;
    } else if (exception is ServerException) {
      return 'Server error. Please try again later.';
    } else {
      return exception.message;
    }
  }
}
