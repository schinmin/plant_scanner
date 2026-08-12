import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/constant/api_constant.dart';
import 'package:plant_scanner_app/core/database/shared_prefercences.dart';

class ApiService {
  late Dio dio;

  String? _authToken;

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
          _authToken ??= await localStorageService.getUserToken();

          // ✅ Add Bearer token to headers
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
            debugPrint('🔑 Bearer Token added');
          } else {
            debugPrint('⚠️ No Bearer Token found');
          }
          debugPrint('========== API REQUEST ==========');
          debugPrint('Request: ${options.method} ${options.uri}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Data: ${options.data}');

          handler.next(options);
        },

        onResponse: (response, handler) {
          debugPrint('========== API RESPONSE ==========');
          debugPrint('Status: ${response.statusCode}');
          debugPrint('Data: ${response.data}');
          debugPrint('Headers: ${response.headers}');
          debugPrint(
            'Request: ${response.requestOptions.method} '
            '${response.requestOptions.uri}',
          );

          handler.next(response);
        },

        onError: (DioException e, handler) {
          debugPrint('========== API ERROR ==========');
          debugPrint('Type: ${e.type}');
          debugPrint('Message: ${e.message}');
          debugPrint('Status: ${e.response?.statusCode}');
          debugPrint('Response: ${e.response?.data}');
          debugPrint('Headers: ${e.response?.headers}');
          debugPrint(
            'Request: ${e.requestOptions.method} '
            '${e.requestOptions.uri}',
          );

          handler.next(e);
        },
      ),
    );
  }
}
