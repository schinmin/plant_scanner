// lib/constants/regions.dart

import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/region_model.dart';

class MyanmarRegions {
  // ==========================================
  // ပြည်ထောင်စုနယ်မြေ
  // ==========================================
  static final Region naypyitaw = Region(
    id: 'naypyitaw',
    nameMm: 'နေပြည်တော်',
    nameEn: 'Nay Pyi Taw',
    type: 'ပြည်ထောင်စုနယ်မြေ',
  );

  // ==========================================
  // တိုင်းဒေသကြီးများ
  // ==========================================
  static final List<Region> regions = [
    Region(
      id: 'yangon',
      nameMm: 'ရန်ကုန်',
      nameEn: 'Yangon',
      type: 'တိုင်းဒေသကြီး',
    ),
    Region(
      id: 'mandalay',
      nameMm: 'မန္တလေး',
      nameEn: 'Mandalay',
      type: 'တိုင်းဒေသကြီး',
    ),
    Region(id: 'bago', nameMm: 'ပဲခူး', nameEn: 'Bago', type: 'တိုင်းဒေသကြီး'),
    Region(
      id: 'ayeyarwady',
      nameMm: 'ဧရာဝတီ',
      nameEn: 'Ayeyarwady',
      type: 'တိုင်းဒေသကြီး',
    ),
    Region(
      id: 'tanintharyi',
      nameMm: 'တနင်္သာရီ',
      nameEn: 'Tanintharyi',
      type: 'တိုင်းဒေသကြီး',
    ),
    Region(
      id: 'sagaing',
      nameMm: 'စစ်ကိုင်း',
      nameEn: 'Sagaing',
      type: 'တိုင်းဒေသကြီး',
    ),
    Region(
      id: 'magway',
      nameMm: 'မကွေး',
      nameEn: 'Magway',
      type: 'တိုင်းဒေသကြီး',
    ),
  ];

  // ==========================================
  // ပြည်နယ်များ
  // ==========================================
  static final List<Region> states = [
    Region(id: 'kachin', nameMm: 'ကချင်', nameEn: 'Kachin', type: 'ပြည်နယ်'),
    Region(id: 'kayah', nameMm: 'ကယား', nameEn: 'Kayah', type: 'ပြည်နယ်'),
    Region(id: 'kayin', nameMm: 'ကရင်', nameEn: 'Kayin', type: 'ပြည်နယ်'),
    Region(id: 'chin', nameMm: 'ချင်း', nameEn: 'Chin', type: 'ပြည်နယ်'),
    Region(id: 'mon', nameMm: 'မွန်', nameEn: 'Mon', type: 'ပြည်နယ်'),
    Region(id: 'rakhine', nameMm: 'ရခိုင်', nameEn: 'Rakhine', type: 'ပြည်နယ်'),
    Region(id: 'shan', nameMm: 'ရှမ်း', nameEn: 'Shan', type: 'ပြည်နယ်'),
  ];

  // ==========================================
  // အားလုံးပေါင်းထားသော စာရင်း
  // ==========================================
  static final List<Region> all = [naypyitaw, ...regions, ...states];

  // ==========================================
  // Dropdown Items (Grouped)
  // ==========================================
  static List<DropdownMenuItem<Region>> getGroupedDropdownItems() {
    final items = <DropdownMenuItem<Region>>[];

    // 1. ပြည်ထောင်စုနယ်မြေ
    items.add(
      const DropdownMenuItem<Region>(
        value: null,
        enabled: false,
        child: Text(
          '--- ပြည်ထောင်စုနယ်မြေ ---',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
    );
    items.add(
      DropdownMenuItem<Region>(
        value: naypyitaw,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(naypyitaw.displayName),
        ),
      ),
    );

    // 2. တိုင်းဒေသကြီးများ
    items.add(
      const DropdownMenuItem<Region>(
        value: null,
        enabled: false,
        child: Text(
          '--- တိုင်းဒေသကြီးများ ---',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
    );
    items.addAll(
      regions.map((region) {
        return DropdownMenuItem<Region>(
          value: region,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(region.displayName),
          ),
        );
      }).toList(),
    );

    // 3. ပြည်နယ်များ
    items.add(
      const DropdownMenuItem<Region>(
        value: null,
        enabled: false,
        child: Text(
          '--- ပြည်နယ်များ ---',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
    );
    items.addAll(
      states.map((region) {
        return DropdownMenuItem<Region>(
          value: region,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(region.displayName),
          ),
        );
      }).toList(),
    );

    return items;
  }
}
