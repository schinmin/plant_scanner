import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/constant/api_constant.dart';
import 'package:plant_scanner_app/core/database/shared_prefercences.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authToken = await localStorageService.getUserToken();

          // ✅ Add Bearer token to headers
          if (authToken != null && authToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $authToken';
          } else {
            options.headers.remove('Authorization');
          }
          debugPrint('API request: ${options.method} ${options.path}');

          handler.next(options);
        },

        onResponse: (response, handler) {
          debugPrint(
            'API response: ${response.statusCode} '
            '${response.requestOptions.method} ${response.requestOptions.path}',
          );

          handler.next(response);
        },

        onError: (DioException e, handler) {
          debugPrint(
            'API error: ${e.type} ${e.response?.statusCode} '
            '${e.requestOptions.method} ${e.requestOptions.path}',
          );

          handler.next(e);
        },
      ),
    );
  }
}
