// lib/constants/soil_data.dart

import 'package:plant_scanner_app/plant_simulation/data/models/region_model.dart';

class SoilData {
  // ဒေသအလိုက် မြေအမျိုးအစားစာရင်း
  static final Map<String, List<String>> regionSoilTypes = {
    // ကချင်ပြည်နယ်
    'kachin': [
      'မြေနုနယ် (Alluvial Soil)',
      'သဲနုန်းမြေ (Loamy Sand)',
      'သဲစေးမြေ (Sandy Clay)',
      'နုန်းစေးမြေ (Silty Clay)',
      'သဲမြေ (Sandy Soil)',
      'စေးမြေ (Clay Soil)',
      'သဲနုန်းစေးမြေ (Sandy Clay Loam)',
    ],
    // ကယားပြည်နယ်
    'kayah': [
      'စေးနုန်းမြေ (Clay Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'တောင်ပေါ်အညိုရောင်သစ်တောမြေ (Mountainous Brown Forest Soil)',
    ],
    // ကရင်ပြည်နယ်
    'kayin': [
      'စေးမြေ (Clay Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'နုန်းမြေ (Silty Loam)',
      'သဲစေးမြေ (Sandy Clay)',
      'အညိုရောင်သစ်တောမြေ (Brown Forest Soil)',
    ],
    // ချင်းပြည်နယ်
    'chin': [
      'နုန်းမြေ (Silty Loam)',
      'စေးနုန်းမြေ (Clay Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'ချင်းတောင်တန်း ရှုပ်ထွေးမြေ (Chin Hills Complex Soil)',
    ],
    // စစ်ကိုင်းတိုင်းဒေသကြီး
    'sagaing': [
      'မြေနုနယ် (Alluvial Soil)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'စေးမြေ (Clay Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'နုန်းစေးမြေ (Silty Clay)',
      'သဲစေးမြေ (Sandy Clay)',
    ],
    // တနင်္သာရီတိုင်းဒေသကြီး
    'tanintharyi': [
      'စေးနုန်းမြေ (Clay Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'နုန်းစေးမြေ (Silty Clay)',
      'စေးမြေ (Clay Soil)',
      'နုန်းမြေ (Silty Loam)',
      'သဲစေးမြေ (Sandy Clay)',
    ],
    // ပဲခူးတိုင်းဒေသကြီး
    'bago': [
      'မြေနုနယ် (Alluvial Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'နုန်းမြေ (Silty Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'သဲစေးမြေ (Sandy Clay)',
      'စေးမြေ (Clay Soil)',
    ],
    // မကွေးတိုင်းဒေသကြီး
    'magway': [
      'သဲနုန်းမြေ (Sandy Loam)',
      'စေးမြေ (Clay Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'နုန်းမြေ (Silty Loam)',
      'သဲစေးမြေ (Sandy Clay)',
      'ကြေမွနေသောကျောက်မြေ (Crushed Stone Soil - Leptosol)',
    ],
    // မန္တလေးတိုင်းဒေသကြီး
    'mandalay': [
      'မြေနုနယ် (Alluvial Soil)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'စေးနုန်းမြေ (Clay Loam)',
      'စေးမြေ (Clay Soil)',
      'နုန်းစေးမြေ (Silty Clay)',
      'ပိုပါမီးတောင်မြေ (Popa Volcanic Soil - Andosol)',
    ],
    // မွန်ပြည်နယ်
    'mon': [
      'အညိုရောင်သစ်တောမြေ (Brown Forest Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'စေးမြေ (Clay Soil)',
    ],
    // ရခိုင်ပြည်နယ်
    'rakhine': [
      'မြေနုနယ် (Alluvial Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'စေးမြေ (Clay Soil)',
      'ကြေမွနေသောကျောက်မြေ (Crushed Stone Soil - Leptosol)',
    ],
    // ရန်ကုန်တိုင်းဒေသကြီး
    'yangon': [
      'မြေနုနယ် (Alluvial Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'စေးမြေ (Clay Soil)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'နုန်းစေးမြေ (Silty Clay)',
      'မြစ်ဝကျွန်းပေါ်စေးမြေ (Deltaic Plain Clay Soil)',
    ],
    // ရှမ်းပြည်နယ်
    'shan': [
      'နီမြေ (Red Earth)',
      'ဝါမြေ (Yellow Earth)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'စေးနုန်းမြေ (Clay Loam)',
      'တောင်ပေါ်အညိုရောင်သစ်တောမြေ (Mountainous Brown Forest Soil)',
      'အညိုဝါတောင်ပေါ်မြေ (Yellowish Brown Mountain Soil)',
    ],
    // နေပြည်တော်
    'naypyitaw': [
      'မြေနုနယ် (Alluvial Soil)',
      'စေးနုန်းမြေ (Clay Loam)',
      'သဲနုန်းမြေ (Sandy Loam)',
      'စေးမြေ (Clay Soil)',
      'သဲစေးမြေ (Sandy Clay)',
    ],
  };

  // ရွေးချယ်ထားတဲ့ ဒေသအတွက် မြေအမျိုးအစားတွေ ရယူခြင်း
  static List<String> getSoilTypesForRegion(Region? region) {
    if (region == null) return [];
    return regionSoilTypes[region.id] ?? [];
  }
}
