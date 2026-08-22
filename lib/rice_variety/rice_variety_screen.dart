import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/main_home.dart';
import 'package:plant_scanner_app/rice_variety/mock_rice_service.dart';
import 'package:plant_scanner_app/rice_variety/rice_model.dart';

class RiceSphereApp extends StatelessWidget {
  const RiceSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[50],
        primaryColor: const Color(0xFF2E7D32),
        useMaterial3: true,
      ),
      home: const RiceListPage(),
    );
  }
}

// ==========================================
// SCREEN 1: RICE LIST PAGE (Image 1)
// ==========================================
class RiceListPage extends StatefulWidget {
  const RiceListPage({super.key});

  @override
  State<RiceListPage> createState() => _RiceListPageState();
}

class _RiceListPageState extends State<RiceListPage> {
  final RiceService _service = RiceService();
  late Future<List<RiceVariety>> _riceFuture;

  @override
  void initState() {
    super.initState();
    _riceFuture = _service.fetchRiceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ဆန်အမျိုးအစားများ',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainHome()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Text(
              'မြန်မာနိုင်ငံတွင် စိုက်ပျိုးသော ဆန်မျိုးများကို လေ့လာပါ',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.blue),
                  hintText: 'ဆန်အမည် သို့မဟုတ် စိုက်ပျိုးရာဒေသ ရှာဖွေပါ...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Rice Grid List
            Expanded(
              child: FutureBuilder<List<RiceVariety>>(
                future: _riceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('ဆန်မျိုးများ မတွေ့ပါ'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7, // Adjust for card height
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final rice = snapshot.data![index];
                      return RiceGridCard(rice: rice);
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

class RiceGridCard extends StatelessWidget {
  final RiceVariety rice;
  const RiceGridCard({super.key, required this.rice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RiceDetailPage(riceId: rice.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  rice.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  cacheWidth: 600,
                ),
              ),
            ),
            // Content
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rice.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B3A4B),
                      ),
                    ),
                    Text(
                      rice.nameEn,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                rice.regions.join(', '),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.grain,
                              size: 12,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'စိုက်ပျိုးသက်တမ်း: ၁၂၀-၁၃၅ ရက်',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${rice.price}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
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
// SCREEN 2: RICE DETAIL PAGE (Images 2, 3, 4)
// ==========================================
class RiceDetailPage extends StatefulWidget {
  final String riceId;
  const RiceDetailPage({super.key, required this.riceId});

  @override
  State<RiceDetailPage> createState() => _RiceDetailPageState();
}

class _RiceDetailPageState extends State<RiceDetailPage> {
  final RiceService _service = RiceService();
  late Future<RiceVariety> _riceDetailFuture;

  @override
  void initState() {
    super.initState();
    _riceDetailFuture = _service.fetchRiceDetail(widget.riceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ဆန်အမျိုးအစားအသေးစိတ်',
          style: TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
        ),
      ),
      body: FutureBuilder<RiceVariety>(
        future: _riceDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('အချက်အလက်များ ရှာမတွေ့ပါ'));
          }
          final rice = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Image & Title
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    rice.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: 800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  rice.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A4B),
                  ),
                ),
                Text(
                  rice.nameEn,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  rice.description,
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 8,
                  children: rice.tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            '✓ $tag',
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: Colors.green.withOpacity(0.1),
                          padding: EdgeInsets.zero,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),

                // 2. Stats Info Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.monetization_on,
                        '${rice.price} ရက်',
                        'သက်တမ်း',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        Icons.agriculture,
                        '${rice.yields} တင်း/ဧက',
                        'ထွက်နှုန်းအချက်',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.water_drop,
                        rice.waterLevel,
                        'ရေအသုံးပြုမှု',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        Icons.grass,
                        rice.seedType,
                        'အစေ့အမျိုးအစား',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 3. Pests & Diseases List (Image 3)
                _buildSectionTitle('🐛 စိုက်ပျိုးရေး ပြဿနာများ'),
                const SizedBox(height: 8),
                ...rice.pests.map(
                  (pest) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(pest.icon, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pest.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          pest.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Sowing Regions
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📍 စိုက်ပျိုးနိုင်သော ဒေသများ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: rice.sowingRegions
                            .map(
                              (r) => Chip(
                                label: Text(r),
                                backgroundColor: Colors.pink.withOpacity(0.1),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Fertilizer Schedules (Image 4)
                _buildSectionTitle('🧪 မြေသြဇာ ကျွေးပါက နည်း (တစ်ဧက)'),
                const SizedBox(height: 8),
                ...rice.fertilizerSchedules.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  var schedule = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            '$index',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'မြေသြဇာ ${schedule.stage} (${schedule.growthDay} ရက်)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${schedule.chemical} - ${schedule.ratio}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    '© 2026 RiceSphere Myanmar | Data Source: DAR Myanmar',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[700], size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B3A4B),
        ),
      ),
    );
  }
}
