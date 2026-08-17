import 'package:plant_scanner_app/soil_variety/soil_type_model.dart';

class SoilService {
  // Mock Data for the Soil List
  Future<List<SoilType>> fetchSoilList() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      SoilType(
        id: '1',
        name: 'နုန်းမြေ',
        nameEn: 'Alluvial Soil',
        imageUrl:
            'https://images.unsplash.com/photo-1592419044706-39796d40f98c?q=80&w=1000&auto=format&fit=crop',
        description:
            'မြစ်ချောင်းများ ရေလျှံတိုက်စားမှုကြောင့် ဖြစ်ပေါ်လာသော မြေအမျိုးအစားဖြစ်သည်။ အာဟာရဓာတ်ကြွယ်ဝပြီး စိုက်ပျိုးရေးအတွက် အလွန်ကောင်းမွန်သည်။',
        advantages: [
          'အာဟာရဓာတ် ကြွယ်ဝ',
          'ရေထိန်းအား ကောင်း',
          'သီးနှံအမျိုးစုံ စိုက်ပျိုးနိုင်',
        ],
        disadvantages: ['ရေဝပ်လွယ်ခြင်း', 'အက်ဆစ်ဓာတ် အနည်းငယ် များနိုင်ခြင်း'],
        suitableCrops: ['ဆန်စပါး', 'ပဲအမျိုးမျိုး', 'နှံစားသီးနှံများ'],
        waterRetention: 'High',
        phLevel: '5.5 - 6.5',
      ),
      SoilType(
        id: '2',
        name: 'သဲမြေ',
        nameEn: 'Sandy Soil',
        imageUrl:
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1000&auto=format&fit=crop',
        description:
            'သဲမှုန်များ ပါဝင်မှုများသော မြေအမျိုးအစားဖြစ်သည်။ ရေစစ်ထွက်မှု မြန်ဆန်ပြီး လေဝင်လေထွက် ကောင်းမွန်သည်။',
        advantages: [
          'ရေစစ်ထွက်မှုမြန်',
          'လေဝင်လေထွက်ကောင်း',
          'အမြစ်များ လွယ်ကူစွာ ထိုးဖောက်နိုင်',
        ],
        disadvantages: ['ရေနှင့် အာဟာရဓာတ် ထိန်းသိမ်းမှု အားနည်း'],
        suitableCrops: ['မြေပဲ', 'ပြောင်း', 'ကန်စွန်းဥ', 'ဖရဲသီး'],
        waterRetention: 'Low',
        phLevel: '5.0 - 6.0',
      ),
      // SoilType(
      //   id: '3',
      //   name: 'ရွှံ့မြေ',
      //   nameEn: 'Clay Soil',
      //   imageUrl:
      //       'https://images.unsplash.com/photo-1615916564845-51961d80849f?q=80&w=1000&auto=format&fit=crop',
      //   description:
      //       'အမှုန်အမွှားများ သေးငယ်ပြီး စေးကပ်သော မြေအမျိုးအစားဖြစ်သည်။ ရေကို အလွန်ကောင်းစွာ ထိန်းထားနိုင်စွမ်းရှိသည်။',
      //   advantages: ['ရေထိန်းအား အလွန်ကောင်း', 'အာဟာရဓာတ် ထိန်းသိမ်းမှုကောင်း'],
      //   disadvantages: ['ရေဝပ်လွယ်ခြင်း', 'မာကျောပြီး ထွန်ယက်ရခက်ခြင်း'],
      //   suitableCrops: ['ဆန်စပါး', 'ကြံ', 'ဂျုံ'],
      //   waterRetention: 'Very High',
      //   phLevel: '6.0 - 7.5',
      // ),
    ];
  }

  // Mock Detail Fetch
  Future<SoilType> fetchSoilDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = await fetchSoilList();
    return list.firstWhere((element) => element.id == id);
  }
}
