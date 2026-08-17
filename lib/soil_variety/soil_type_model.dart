class SoilType {
  final String id;
  final String name; // မြေအမျိုးအစားအမည်
  final String nameEn; // English Name
  final String imageUrl;
  final String description;
  final List<String> advantages; // အားသာချက်များ
  final List<String> disadvantages; // အားနည်းချက်များ
  final List<String> suitableCrops; // သင့်တော်သော သီးနှံများ
  final String waterRetention; // ရေထိန်းနိုင်မှု (High/Medium/Low)
  final String phLevel; // pH အဆင့်

  SoilType({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.imageUrl,
    required this.description,
    required this.advantages,
    required this.disadvantages,
    required this.suitableCrops,
    required this.waterRetention,
    required this.phLevel,
  });
}
