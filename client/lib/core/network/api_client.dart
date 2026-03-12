import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger = Logger();

  ApiClient({String baseUrl = 'http://82.25.180.20/stock/api/'})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logger.i(
            'REQUEST[${options.method}] => PATH: ${options.path}\n'
            'DATA: ${options.data}\n'
            'HEADERS: ${options.headers}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}\n'
            'DATA: ${response.data}',
          );
          return handler.next(response);
        },
        onError: (err, handler) {
          _logger.e(
            'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n'
            'MESSAGE: ${err.message}\n'
            'RESPONSE DATA: ${err.response?.data}',
          );
          return handler.next(err);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
