import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/database/shared_prefercences.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initialize() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Authorization Status : ${settings.authorizationStatus}');

    _firebaseMessaging.onTokenRefresh.listen((token) async {
      if (token.isNotEmpty) {
        await localStorageService.saveFcmToken(token);
        debugPrint('FCM token refreshed and saved');
      }
    });

    final token = await _firebaseMessaging.getToken();

    if (token != null && token.isNotEmpty) {
      await localStorageService.saveFcmToken(token);
    }

    return token;
  }
}
