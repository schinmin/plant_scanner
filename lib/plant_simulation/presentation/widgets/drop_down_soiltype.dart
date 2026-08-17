// lib/widgets/soil_type_dropdown.dart

import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/constant/soil_data.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/region_model.dart';

class SoilTypeDropdown extends StatefulWidget {
  final Region? selectedRegion;
  final String selectedSoilType; // ✅ String (required) ဖြစ်အောင်ပြောင်းပါ
  final ValueChanged<String> onChanged; // ✅ String ပြန်ပေးမယ်
  final String? label;
  final String? hintText;
  final bool isRequired;
  final String? errorText;

  const SoilTypeDropdown({
    Key? key,
    this.selectedRegion,
    required this.selectedSoilType, // ✅ required
    required this.onChanged,
    this.label,
    this.hintText,
    this.isRequired = false,
    this.errorText,
  }) : super(key: key);

  @override
  State<SoilTypeDropdown> createState() => _SoilTypeDropdownState();
}

class _SoilTypeDropdownState extends State<SoilTypeDropdown> {
  List<String> _soilTypes = [];
  String _selectedSoilType = ''; // ✅ String (null မဖြစ်နိုင်)

  @override
  void initState() {
    super.initState();
    _selectedSoilType = widget.selectedSoilType;
    _updateSoilTypes();
  }

  @override
  void didUpdateWidget(SoilTypeDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRegion?.id != oldWidget.selectedRegion?.id) {
      _updateSoilTypes();
      // Region ပြောင်းရင် ရွေးထားတဲ့ soil type ကို ရှင်းလိုက်ပါ
      if (widget.selectedSoilType.isEmpty) {
        setState(() {
          _selectedSoilType = '';
        });
      }
    }
    if (widget.selectedSoilType != oldWidget.selectedSoilType) {
      setState(() {
        _selectedSoilType = widget.selectedSoilType;
      });
    }
  }

  void _updateSoilTypes() {
    setState(() {
      _soilTypes = SoilData.getSoilTypesForRegion(widget.selectedRegion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              if (widget.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
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
          child: DropdownButtonFormField<String>(
            value: _selectedSoilType.isNotEmpty ? _selectedSoilType : null,
            isExpanded: true,
            hint: Text(
              widget.selectedRegion == null
                  ? 'ကျေးဇူးပြု၍ ဒေသရွေးပါ'
                  : (widget.hintText ?? 'မြေအမျိုးအစားရွေးပါ'),
              style: TextStyle(
                color: widget.selectedRegion == null
                    ? Colors.grey.shade400
                    : Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
            items: _soilTypes.map((soilType) {
              return DropdownMenuItem<String>(
                value: soilType,
                child: Text(soilType),
              );
            }).toList(),
            onChanged: widget.selectedRegion == null
                ? null
                : (String? newValue) {
                    setState(() {
                      _selectedSoilType = newValue ?? '';
                    });
                    widget.onChanged(newValue ?? ''); // ✅ String ပြန်ပေးမယ်
                  },
            validator: (value) {
              if (widget.isRequired && (value == null || value.isEmpty)) {
                return 'မြေအမျိုးအစား ရွေးချယ်ပါ';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: widget.label,
              prefixIcon: Icon(
                Icons.landscape,
                color: widget.selectedRegion == null
                    ? Colors.grey.shade400
                    : Colors.green.shade700,
              ),
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
            icon: Icon(
              Icons.arrow_drop_down,
              color: widget.selectedRegion == null
                  ? Colors.grey.shade400
                  : Colors.green.shade700,
            ),
            dropdownColor: Colors.white,
            iconSize: 28,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        if (widget.selectedRegion == null && _soilTypes.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'ပထမဆုံး ဒေသရွေးချယ်ပါ',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
