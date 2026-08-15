import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      return AiResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint(
        'Plant scan request failed: ${e.type} ${e.response?.statusCode}',
      );
      throw Exception('Failed to get response: ${e.message}');
    } catch (e) {
      debugPrint('Plant scan response could not be processed');
      throw Exception('Failed to get response: $e');
      // Handle exceptions
    }
    // Implementation for getting response from data source
  }
}
