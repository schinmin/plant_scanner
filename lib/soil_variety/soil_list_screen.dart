import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/main_home.dart';
import 'package:plant_scanner_app/soil_variety/mock_soil_service.dart';
import 'package:plant_scanner_app/soil_variety/soil_type_model.dart';

class SoilListPage extends StatefulWidget {
  const SoilListPage({super.key});

  @override
  State<SoilListPage> createState() => _SoilListPageState();
}

class _SoilListPageState extends State<SoilListPage> {
  final SoilService _service = SoilService();
  late Future<List<SoilType>> _soilFuture;

  @override
  void initState() {
    super.initState();
    _soilFuture = _service.fetchSoilList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'မြေအမျိုးအစားများ',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainHome()),
            );
          }, // Navigate back to home if needed
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Text(
              'မြန်မာနိုင်ငံတွင် တွေ့ရသော မြေအမျိုးအစားများနှင့် ၎င်းတို့၏ ဂုဏ်သတ္တိများ',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<SoilType>>(
                future: _soilFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('မြေအမျိုးအစားများ မတွေ့ပါ'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final soil = snapshot.data![index];
                      return SoilListCard(soil: soil);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Soil List Card
class SoilListCard extends StatelessWidget {
  final SoilType soil;
  const SoilListCard({super.key, required this.soil});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SoilDetailPage(soilId: soil.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Image.network(
                soil.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      soil.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B3A4B),
                      ),
                    ),
                    Text(
                      soil.nameEn,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      soil.description.length > 50
                          ? '${soil.description.substring(0, 50)}...'
                          : soil.description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.water_drop,
                              size: 14,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ရေထိန်းအား: ${soil.waterRetention}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: SOIL DETAIL PAGE
// ==========================================
class SoilDetailPage extends StatefulWidget {
  final String soilId;
  const SoilDetailPage({super.key, required this.soilId});

  @override
  State<SoilDetailPage> createState() => _SoilDetailPageState();
}

class _SoilDetailPageState extends State<SoilDetailPage> {
  final SoilService _service = SoilService();
  late Future<SoilType> _soilDetailFuture;

  @override
  void initState() {
    super.initState();
    _soilDetailFuture = _service.fetchSoilDetail(widget.soilId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'မြေအမျိုးအစားအသေးစိတ်',
          style: TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: FutureBuilder<SoilType>(
        future: _soilDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('အချက်အလက်များ ရှာမတွေ့ပါ'));
          }
          final soil = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    soil.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  soil.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A4B),
                  ),
                ),
                Text(
                  soil.nameEn,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Description
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    soil.description,
                    style: TextStyle(color: Colors.grey[800], height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),

                // Key Stats (pH and Water)
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.water,
                        soil.waterRetention,
                        'ရေထိန်းနိုင်စွမ်း',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        Icons.science,
                        soil.phLevel,
                        'pH အဆင့်',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Advantages
                _buildSectionTitle('✅ အားသာချက်များ'),
                ...soil.advantages.map(
                  (adv) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            adv,
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Disadvantages
                _buildSectionTitle('⚠️ အားနည်းချက်များ'),
                ...soil.disadvantages.map(
                  (dis) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            dis,
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Suitable Crops
                _buildSectionTitle('🌾 သင့်တော်သော သီးနှံများ'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: soil.suitableCrops
                      .map(
                        (crop) => Chip(
                          label: Text(
                            crop,
                            style: const TextStyle(fontSize: 13),
                          ),
                          backgroundColor: Colors.green.withOpacity(0.1),
                          side: BorderSide.none,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B3A4B),
        ),
      ),
    );
  }
}
