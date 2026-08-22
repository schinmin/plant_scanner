import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// Your Domain Entities / Models
import 'package:plant_scanner_app/pesticide_scan/domain/entity/pesticide_entity.dart';
import 'package:plant_scanner_app/pesticide_scan/presentation/bloc/pesticide_bloc.dart';
import 'package:plant_scanner_app/pesticide_scan/presentation/bloc/pesticide_event.dart';
import 'package:plant_scanner_app/pesticide_scan/presentation/bloc/pesticide_state.dart';

class PesticideScanPage extends StatefulWidget {
  final File? initialImage;

  const PesticideScanPage({super.key, this.initialImage});

  @override
  State<PesticideScanPage> createState() => _PesticideScanPageState();
}

class _PesticideScanPageState extends State<PesticideScanPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  // 📸 Camera / Gallery Image Picker
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        if (mounted) {
          context.read<PesticideBloc>().add(ResetPesticideEvent());
        }
      }
    } catch (e) {
      debugPrint("Image Pick Error: $e");
    }
  }

  // 🏙️ Image Picker BottomSheet
  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ဓာတ်ပုံ ရွေးချယ်ပါ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'ကင်မရာ',
                    color: Colors.green[700]!,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildPickerOption(
                    icon: Icons.photo_library_rounded,
                    label: 'ဂယ်လရီ',
                    color: Colors.blue[700]!,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('ပိုးသတ်ဆေး စစ်ဆေးခြင်း'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'ပုံအသစ်ရွေးရန်',
              onPressed: () => _showImagePickerBottomSheet(context),
            ),
        ],
      ),
      body: BlocConsumer<PesticideBloc, PesticideState>(
        listener: (context, state) {
          if (state is PesticideFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PesticideLoading) {
            return _buildLoadingView();
          } else if (state is PesticideSuccess) {
            return _buildResultView(context, state.result);
          } else if (state is PesticideFailure) {
            return _buildErrorView(context, state.message);
          }

          return _buildImageSelectionView(context);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Initial State: Image Selection View
  // ---------------------------------------------------------------------------
  Widget _buildImageSelectionView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          if (_selectedImage != null) ...[
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    _selectedImage!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: 1080,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => _showImagePickerBottomSheet(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.search_rounded),
                label: const Text(
                  'စစ်ဆေးမှု စတင်ရန်',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  context.read<PesticideBloc>().add(
                    ScanPesticideEvent(_selectedImage!),
                  );
                },
              ),
            ),
          ] else ...[
            const SizedBox(height: 40),
            InkWell(
              onTap: () => _showImagePickerBottomSheet(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_a_photo_rounded,
                        size: 48,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ပိုးသတ်ဆေးဗူး၏ ဓာတ်ပုံကို ရိုက်ပါ သို့မဟုတ် ရွေးပါ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Camera သို့မဟုတ် Gallery မှ ရွေးချယ်နိုင်ပါသည်',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Loading View
  // ---------------------------------------------------------------------------
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green[800]),
          const SizedBox(height: 20),
          const Text(
            'ပိုးသတ်ဆေး အချက်အလက်များကို စစ်ဆေးနေပါသည်...',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            'ခေတ္တ စောင့်ဆိုင်းပေးပါ။',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Scan Result View (Fields အားလုံး ပြသထားသည်)
  // ---------------------------------------------------------------------------
  Widget _buildResultView(BuildContext context, PesticideScanResult result) {
    final guide = result.guide;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ရွေးချယ်ခဲ့သော ဓာတ်ပုံ ပရီဗျူး
          if (_selectedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                _selectedImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),

          // Response Status & Message Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: result.success ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: result.success ? Colors.green[300]! : Colors.red[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  result.success
                      ? Icons.check_circle_rounded
                      : Icons.error_rounded,
                  color: result.success ? Colors.green[700] : Colors.red[700],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.message,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: result.success
                              ? Colors.green[900]
                              : Colors.red[900],
                        ),
                      ),
                      Text(
                        'Status Code: ${result.status}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1. အကျဉ်းချုပ် (Summary)
          _buildInfoCard(
            title: 'အကျဉ်းချုပ် (Summary)',
            icon: Icons.info_outline_rounded,
            iconColor: Colors.green[800]!,
            child: Text(
              guide.summary,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 12),

          // 2. သုံးစွဲရန် ရည်ရွယ်ချက်၊ ခွင့်ပြုထားသော သီးနှံနှင့် ပိုးမွှားများ (Usage, Crops, Pests)
          _buildInfoCard(
            title: 'သုံးစွဲရန် ရည်ရွယ်ချက်နှင့် အသုံးပြုနိုင်သော သီးနှံများ',
            icon: Icons.grass_rounded,
            iconColor: Colors.teal[700]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.usedFor,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),
                _buildChipGroup(
                  'ခွင့်ပြုထားသော သီးနှံများ:',
                  guide.approvedCrops,
                  Colors.green,
                ),
                const SizedBox(height: 10),
                _buildChipGroup(
                  'နှိမ်နင်းနိုင်သော ပိုးမွှားများ:',
                  guide.targetPests,
                  Colors.orange,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. ဆေးနှုန်းထားနှင့် သုံးစွဲနည်း အဆင့်ဆင့် (Dosage, Application Time & How to use)
          _buildInfoCard(
            title: 'အသုံးပြုပုံနှင့် ပမာဏ (Dosage & Instructions)',
            icon: Icons.science_rounded,
            iconColor: Colors.blue[700]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  'ဆေးနှုန်းထား (Dosage):',
                  guide.dosage,
                  Icons.medication_liquid_rounded,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'အကောင်းဆုံး ဖျန်းရမည့်အချိန်:',
                  guide.bestApplicationTime,
                  Icons.access_time_filled_rounded,
                ),
                const SizedBox(height: 14),
                const Text(
                  'အသုံးပြုနည်း အဆင့်ဆင့်:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...guide.howToUse.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${e.key + 1}. ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. ဘေးကင်းလုံခြုံရေးနှင့် ကာကွယ်ရန်များ (Safety Precautions & Protective Equipment)
          _buildInfoCard(
            title: 'ဘေးကင်းလုံခြုံရေးနှင့် ဝတ်ဆင်ရမည့် ကိရိယာများ',
            icon: Icons.shield_rounded,
            iconColor: Colors.red[700]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletList(
                  'လိုက်နာရမည့် ဘေးကင်းရေး နည်းလမ်းများ:',
                  guide.safetyPrecautions,
                  Colors.red[700]!,
                ),
                const SizedBox(height: 12),
                _buildChipGroup(
                  'ဝတ်ဆင်ရမည့် ကာကွယ်ရေး ဝတ်စုံ/ကိရိယာများ:',
                  guide.protectiveEquipment,
                  Colors.indigo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5. သိမ်းဆည်းမှုနှင့် ရှေးဦးသူနာပြု (Storage & First Aid)
          _buildInfoCard(
            title: 'သိမ်းဆည်းမှုနှင့် ရှေးဦးသူနာပြု',
            icon: Icons.medical_services_rounded,
            iconColor: Colors.deepPurple[700]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  'သိမ်းဆည်းနည်း:',
                  guide.storage,
                  Icons.inventory_2_rounded,
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  'ရှေးဦးသူနာပြု ပြုစုနည်း:',
                  guide.firstAid,
                  Icons.healing_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 6. သဘာဝပတ်ဝန်းကျင် သတိပေးချက် (Environment Warning)
          if (guide.environmentWarning.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber[400]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber[900]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'သဘာဝပတ်ဝန်းကျင် သတိပေးချက်',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          guide.environmentWarning,
                          style: TextStyle(
                            color: Colors.amber[950],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 7. အရေးကြီး သတိပြုရန်များ (Important Notes)
          if (guide.importantNotes.isNotEmpty)
            _buildInfoCard(
              title: 'အရေးကြီး သတိပြုရန်များ',
              icon: Icons.note_alt_rounded,
              iconColor: Colors.orange[800]!,
              child: _buildBulletList('', guide.importantNotes, Colors.black87),
            ),

          const SizedBox(height: 24),

          // ပုံအသစ် ပြန်လည် စစ်ဆေးရန် Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.green[800]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                Icons.center_focus_weak_rounded,
                color: Colors.green[800],
              ),
              label: Text(
                'အခြားပုံ ထပ်မံ စစ်ဆေးမည်',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              onPressed: () {
                _showImagePickerBottomSheet(context);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Error View
  // ---------------------------------------------------------------------------
  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => _showImagePickerBottomSheet(context),
                  child: const Text('ပုံအသစ်ရွေးမည်'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                  ),
                  onPressed: () {
                    if (_selectedImage != null) {
                      context.read<PesticideBloc>().add(
                        ScanPesticideEvent(_selectedImage!),
                      );
                    }
                  },
                  child: const Text(
                    'ပြန်လည် ကြိုးစားမည်',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable Component Helpers
  // ---------------------------------------------------------------------------

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[850],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipGroup(String label, List<String> items, Color color) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: -4,
          children: items
              .map(
                (item) => Chip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  backgroundColor: color.withOpacity(0.08),
                  side: BorderSide(color: color.withOpacity(0.2)),
                  visualDensity: VisualDensity.compact,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBulletList(String title, List<String> items, Color bulletColor) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
        ],
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    color: bulletColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(height: 1.4, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
