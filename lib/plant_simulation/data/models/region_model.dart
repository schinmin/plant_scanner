// lib/models/region.dart

class Region {
  final String id;
  final String nameMm;
  final String nameEn;
  final String type; // 'တိုင်းဒေသကြီး' or 'ပြည်နယ်' or 'ပြည်ထောင်စုနယ်မြေ'

  Region({
    required this.id,
    required this.nameMm,
    required this.nameEn,
    required this.type,
  });

  String get displayName =>
      type == 'ပြည်ထောင်စုနယ်မြေ' ? nameMm : '$nameMm ($type)';
}
