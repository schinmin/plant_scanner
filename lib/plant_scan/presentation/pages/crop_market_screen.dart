import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';
import 'package:plant_scanner_app/plant_scan/presentation/crop_prices/crop_prices_bloc.dart';

class CropMarketScreen extends StatefulWidget {
  const CropMarketScreen({super.key});

  @override
  State<CropMarketScreen> createState() => _CropMarketScreenState();
}

class _CropMarketScreenState extends State<CropMarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCrops(page: 1, search: '');
    });
    _scrollController.addListener(_onScroll);
  }

  void _fetchCrops({required int page, required String search}) {
    context.read<CropPricesBloc>().add(
      GetCropMarketEvent(page: page, search: search),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<CropPricesBloc>().state;
      if (state is CropPricesLoadedState &&
          !_isLoadingMore &&
          state.hasMoreData) {
        setState(() {
          _isLoadingMore = true;
          _currentPage++;
        });
        _fetchCrops(page: _currentPage, search: _searchQuery);
      }
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1;
    });
    _fetchCrops(page: 1, search: value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),
      body: SafeArea(
        child: BlocConsumer<CropPricesBloc, CropPricesState>(
          listener: (context, state) {
            if (state is CropPricesLoadedState) {
              setState(() {
                _isLoadingMore = false;
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _SearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
                if (state is CropPricesLoadedState)
                  _MarketStats(
                    totalItems: state.cropmarkets.length,
                    totalLocations: state.cropmarkets
                        .map((e) => e.location)
                        .toSet()
                        .length,
                  ),
                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(CropPricesState state) {
    if (state is CropPricesLoadingState && _currentPage == 1) {
      return const _LoadingState();
    } else if (state is CropPricesLoadedErrorState && _currentPage == 1) {
      return _ErrorState(
        errorMessage: state.errorMessage,
        onRetry: () {
          _currentPage = 1;
          _fetchCrops(page: 1, search: _searchQuery);
        },
      );
    } else if (state is CropPricesLoadedState) {
      final cropMarkets = state.cropmarkets;

      if (cropMarkets.isEmpty) {
        return _EmptyState();
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        itemCount: cropMarkets.length + (state.hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < cropMarkets.length) {
            final crop = cropMarkets[index];
            return _CropCard(crop: crop);
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      );
    }
    return const Center(child: Text("No Data Available"));
  }
}

// ============= SEARCH BAR =============
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE1E9DF)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B5E20).withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF55745B),
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF66806B),
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : null,
            hintText: 'သီးနှံ၊ မြို့နယ် သို့မဟုတ် စျေးကွက် ရှာရန်...',
            hintStyle: const TextStyle(color: Color(0xFF91A195), fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// ============= MARKET STATS =============
class _MarketStats extends StatelessWidget {
  final int totalItems;
  final int totalLocations;

  const _MarketStats({required this.totalItems, required this.totalLocations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE1E9DF)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.eco_outlined,
                label: 'Crops',
                value: totalItems.toString(),
                color: const Color(0xFF2E7D32),
              ),
            ),
            Container(
              width: 1,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0xFFE1E9DF),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.location_on_outlined,
                label: 'Locations',
                value: totalLocations.toString(),
                color: const Color(0xFF00796B),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 7, color: Color(0xFF2E7D32)),
                  SizedBox(width: 5),
                  Text(
                    'Live',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF1B5E20),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 9),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF203024),
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF718075),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============= CROP CARD =============
class _CropCard extends StatelessWidget {
  final CropMarket crop;

  const _CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    final cropName = _value(crop.name, 'Unknown crop');
    final accent = _getCropColor(cropName);
    final marketplace = _value(crop.marketPlace, 'Market not specified');
    final location = _value(crop.location, 'Location not specified');
    final currency = _value(crop.currency, 'MMK');
    final unit = _value(crop.unit, 'unit');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE1E9DF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _showCropDetails(context, crop, accent),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [accent.withValues(alpha: 0.72), accent],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          cropName.characters.first.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cropName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF17211A),
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: Color(0xFF66806B),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF66806B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F6EF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ဈေးနှုန်းအကွာအဝေး',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: accent,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_price(crop.minPrice)} – ${_price(crop.maxPrice)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF203024),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$currency / $unit',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      size: 16,
                      color: Color(0xFF718075),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        marketplace,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718075),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (crop.updatedAt != null)
                      Text(
                        DateFormat('dd MMM').format(crop.updatedAt!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF91A195),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _value(String? value, String fallback) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? fallback : trimmed;
  }

  String _price(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? '—' : normalized;
  }

  Color _getCropColor(String cropName) {
    const colors = [
      Color(0xFF2E7D32),
      Color(0xFF00796B),
      Color(0xFF558B2F),
      Color(0xFF5D6F3C),
      Color(0xFF388E3C),
      Color(0xFF00897B),
    ];
    return colors[cropName.hashCode.abs() % colors.length];
  }

  void _showCropDetails(BuildContext context, CropMarket crop, Color accent) {
    final currency = _value(crop.currency, 'MMK');
    final unit = _value(crop.unit, 'unit');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE5DA),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.eco_outlined, color: accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _value(crop.name, 'Unknown crop'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF17211A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${_value(crop.location, 'Unknown location')} · '
                          '${_value(crop.marketPlace, 'Unknown market')}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718075),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _DetailItem(
                      label: 'Min Price',
                      value: '${_price(crop.minPrice)} $currency',
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DetailItem(
                      label: 'Max Price',
                      value: '${_price(crop.maxPrice)} $currency',
                      color: accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Price unit: $unit',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718075),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF718075),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorState({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage),
          ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No results found'));
  }
}
