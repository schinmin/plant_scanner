import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/constant/api_constant.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, next) {
          debugPrint('Request: ${options.method} ${options.path}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Data: ${options.data}');
          // Add any request interceptors here
        },
        onResponse: (response, next) {
          debugPrint('Response: ${response.statusCode} ${response.data}');
          debugPrint('Headers: ${response.headers}');
          debugPrint(
            'Request: ${response.requestOptions.method} ${response.requestOptions.path}',
          );
          // Add any response interceptors here
        },
        onError: (DioException e, next) {
          debugPrint('Error: ${e.message}');
          debugPrint('Status: ${e.response?.statusCode}');
          debugPrint('Headers: ${e.response?.headers}');
          debugPrint(
            'Request: ${e.requestOptions.method} ${e.requestOptions.path}',
          );
          // Add any error interceptors here
        },
      ),
    );
  }
}
