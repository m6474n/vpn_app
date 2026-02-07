import 'dart:developer';
import 'package:dio/dio.dart';

class ApiServices {
  final _dio = Dio();
  String isTokenRequired = 'requiresToken';

  ApiServices() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requiresToken = options.extra[isTokenRequired] != false;

          if (requiresToken) {
            const token = ''; // Placeholder for token logic
            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode ?? 0;

          if (statusCode >= 500) {
            log('Server error with status code: $statusCode');
          } else if (statusCode == 401) {
            log('Unauthorized request');
          } else if (statusCode >= 400) {
            final message = e.response?.data is Map
                ? e.response?.data['message']
                : 'Request failed. Please check your input.';
            log('Client error: $message');
          } else {
            log('Network error: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> getData(String url, {String? token}) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(extra: {isTokenRequired: token != null}),
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.statusCode == 401) {
        log('Unauthorized request');
        return null;
      } else {
        log('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error occurred in getData: $e');
      return null;
    }
  }

  Future<String?> getStringData(String url, {String? token}) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          extra: {isTokenRequired: token != null},
          responseType: ResponseType.plain,
        ),
      );
      if (response.statusCode == 200) {
        return response.data.toString();
      }
      return null;
    } catch (e) {
      log('Error occurred fetching string data: $e');
      return null;
    }
  }
}
