import 'rice_model.dart';

class RiceService {
  // Mock Data for the Grid (Listing Page)
  Future<List<RiceVariety>> fetchRiceList() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay

    return [
      RiceVariety(
        id: '1',
        name: 'ပေါ်ဆန်း',
        nameEn: 'Paw San',
        imageUrl:
            'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=1000&auto=format&fit=crop',
        description: 'မြန်မာနိုင်ငံ၏ အထင်ကရ ငွေကြေးတင်သွင်းသည့် ဆန်မျိုး',
        price: 150,
        yields: 70,
        waterLevel: 'HIGH',
        seedType: 'ခေါ်ရှယ်',
        tags: ['မျိုးကောင်း', 'အထွက်နှုန်း', 'ရောဂါခံနိုင်'],
        regions: ['ဧရာဝတီတိုင်း', 'ပဲခူးတိုင်း', 'ရန်ကုန်တိုင်း', 'မိတ္ထီလာ'],
        sowingRegions: [
          'ဧရာဝတီတိုင်း',
          'ပဲခူးတိုင်း',
          'ရန်ကုန်တိုင်း',
          'မိတ္ထီလာ',
        ],
        pests: [
          PestInfo(
            name: 'ပိုးစိမ်း',
            description: 'ရောက်မည့် ၃-၄ ရက်',
            icon: '🐛',
          ),
          PestInfo(
            name: 'ပိုးဖြူပြောက်',
            description: 'ပေါ်အခါ ၂၀-၂၅ ရက်',
            icon: '🦋',
          ),
        ],
        fertilizerSchedules: [
          FertilizerSchedule(
            stage: '၁',
            chemical: 'Urea 15-15-15',
            ratio: '1:1',
            growthDay: '15',
          ),
          FertilizerSchedule(
            stage: '၂',
            chemical: 'Urea 46%',
            ratio: '2:1',
            growthDay: '25-30',
          ),
        ],
      ),
      RiceVariety(
        id: '2',
        name: 'ဧရာဝဒေသ',
        nameEn: 'Ayeyarwady',
        imageUrl:
            'https://images.unsplash.com/photo-1590794056226-79ef3a8147e1?q=80&w=1000&auto=format&fit=crop',
        description: 'ဧရာဝတီတိုင်း ဒေသထွက် ဆန်စပါးမျိုး',
        price: 140,
        yields: 65,
        waterLevel: 'MEDIUM',
        seedType: 'ရွှေဘို',
        tags: ['အရသာရှိ', 'အနံ့မွှေး'],
        regions: ['ဧရာဝတီတိုင်း', 'ရန်ကုန်တိုင်း'],
        sowingRegions: ['ဧရာဝတီတိုင်း'],
        pests: [],
        fertilizerSchedules: [],
      ),
    ];
  }

  // Mock Data for Detail Page (You would fetch by ID here)
  Future<RiceVariety> fetchRiceDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Just returning the first item for demo purposes
    final list = await fetchRiceList();
    return list.firstWhere((element) => element.id == id);
  }
}
