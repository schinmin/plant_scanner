import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';
import 'package:plant_scanner_app/pesticide_scan/data/models/pesticide_model.dart';

abstract class PesticideRemoteDatasource {
  Future<PesticideScanModel> scanPesticide(File imageFile);
}

class PesticideRemoteDatasourceImpl implements PesticideRemoteDatasource {
  final ApiService apiService;

  PesticideRemoteDatasourceImpl(this.apiService);

  @override
  Future<PesticideScanModel> scanPesticide(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;

      // Multipart Form Data ပြင်ဆင်ခြင်း
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await apiService.dio.post(
        'https://argitech-production.up.railway.app/api/scan-pesticide',
        data: formData,
      );

      if (response.statusCode == 200) {
        return PesticideScanModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to scan pesticide');
      }
    } catch (e, stackTrace) {
      debugPrint("Error ${e.toString()} ${stackTrace.toString()}");
      throw Exception(e.toString());
    }
  }
}
