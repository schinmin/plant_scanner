import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_scan/data/models/ai_response_model.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/ai_response.dart';

abstract class GetResponseDataSource {
  Future<AiResponse> getResponse(String imageFile);
}

class GetResponseDataSourceImpl extends GetResponseDataSource {
  final Dio dio;
  GetResponseDataSourceImpl(this.dio);
  @override
  Future<AiResponse> getResponse(String imageFile) async {
    const String apiEndpoint =
        "https://argitech-production.up.railway.app/api/scan";

    FormData formData = FormData.fromMap({
      'leaf_image': await MultipartFile.fromFile(
        imageFile,
        filename: 'leaf_image.jpg',
      ),
    });

    try {
      final response = await dio.post(apiEndpoint, data: formData);
      debugPrint('Data source received response: ${response.data}');
      return AiResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint(
        'Error: ${e.response?.data}',
      ); // This will show server error details
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Headers: ${e.response?.headers}');
      debugPrint('Dio error: ${e.message}');
      throw Exception('Failed to get response: ${e.message}');
    } catch (e) {
      debugPrint('Error in data source: $e');
      throw Exception('Failed to get response: $e');
      // Handle exceptions
    }
    // Implementation for getting response from data source
  }
}
