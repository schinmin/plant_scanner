import 'package:plant_scanner_app/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      phone: json['phone'],
    );
  }
}
