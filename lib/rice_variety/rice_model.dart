class RiceVariety {
  final String id;
  final String name;
  final String nameEn;
  final String imageUrl;
  final String description;
  final int price; // in Kyat
  final double yields; // in Tann per Acre
  final String waterLevel; // "HIGH", "LOW"
  final String seedType; // "ခေါ်ရှယ်", "ရွှေဘို"
  final List<String> tags;
  final List<String> regions; // Growing regions
  final List<String> sowingRegions; // Regions that can sow
  final List<PestInfo> pests;
  final List<FertilizerSchedule> fertilizerSchedules;

  RiceVariety({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.yields,
    required this.waterLevel,
    required this.seedType,
    required this.tags,
    required this.regions,
    required this.sowingRegions,
    required this.pests,
    required this.fertilizerSchedules,
  });
}

class PestInfo {
  final String name;
  final String description;
  final String icon;

  PestInfo({required this.name, required this.description, required this.icon});
}

class FertilizerSchedule {
  final String stage;
  final String chemical;
  final String ratio;
  final String growthDay;

  FertilizerSchedule({
    required this.stage,
    required this.chemical,
    required this.ratio,
    required this.growthDay,
  });
}
