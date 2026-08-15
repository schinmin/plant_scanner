// lib/widgets/region_dropdown.dart

import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/constant/region_constant.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/region_model.dart';

class RegionDropdown extends StatelessWidget {
  final Region? selectedRegion;
  final ValueChanged<Region?> onChanged;
  final String? label;
  final String? hintText;
  final bool isRequired;
  final String? errorText;

  const RegionDropdown({
    super.key,
    this.selectedRegion,
    required this.onChanged,
    this.label,
    this.hintText,
    this.isRequired = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<Region>(
            value: selectedRegion,
            isExpanded: true,
            hint: Text(
              hintText ?? 'တိုင်းဒေသကြီး/ပြည်နယ် ရွေးပါ',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            items: MyanmarRegions.getGroupedDropdownItems(),
            onChanged: onChanged,
            validator: (value) {
              if (isRequired && value == null) {
                return 'တိုင်းဒေသကြီး/ပြည်နယ် ရွေးချယ်ပါ';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(Icons.location_on, color: Colors.green.shade700),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green.shade700, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            icon: Icon(Icons.arrow_drop_down, color: Colors.green.shade700),
            dropdownColor: Colors.white,
            iconSize: 28,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
