import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Timer? _debounce;

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
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchCrops(page: 1, search: value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("မြန်မာ့ သီးနှံဈေးနှုန်းများ")),
      backgroundColor: const Color(0xFFA6AFB8),
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
                const SizedBox(height: 8),
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
        return const _EmptyState();
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      padding: const EdgeInsets.all(16),
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
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : null,
            hintText: 'သီးနှံ၊ မြို့နယ် သို့မဟုတ် စျေးကွက် ရှာရန်...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
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
      child: Row(
        children: [
          _StatItem(
            icon: Icons.local_offer,
            label: 'Crops',
            value: totalItems.toString(),
            color: Colors.blue[700]!,
            bgColor: Colors.blue[50]!,
          ),
          const SizedBox(width: 8),
          _StatItem(
            icon: Icons.location_on,
            label: 'Locations',
            value: totalLocations.toString(),
            color: Colors.green[700]!,
            bgColor: Colors.green[50]!,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  'Live Updates',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ============= NEW & IMPROVED CROP CARD =============
class _CropCard extends StatelessWidget {
  final CropMarket crop;

  const _CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    final cropColor = _getCropColor(crop.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showCropDetails(context, crop),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Name + Market Place Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cropColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          crop.name.isNotEmpty
                              ? crop.name.substring(0, 1).toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: cropColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  crop.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
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
                    if (crop.marketPlace.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          crop.marketPlace,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, thickness: 0.8),
                ),
                // Bottom Row: Price Breakdown & Unit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Range (${crop.currency})',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${crop.minPrice} - ${crop.maxPrice}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${crop.quantity}  ${crop.unit}',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }

  Color _getCropColor(String cropName) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.orange[800]!,
      Colors.purple[700]!,
      Colors.teal[700]!,
      Colors.indigo[700]!,
    ];
    return colors[cropName.hashCode.abs() % colors.length];
  }

  void _showCropDetails(BuildContext context, CropMarket crop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              crop.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${crop.location} ${crop.marketPlace.isNotEmpty ? "- ${crop.marketPlace}" : ""}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    label: 'Min Price',
                    value: '${crop.minPrice} ${crop.currency}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DetailItem(
                    label: 'Max Price',
                    value: '${crop.maxPrice} ${crop.currency}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DetailItem(label: 'Unit', value: crop.unit!),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DetailItem(
                    label: 'Last Updated',
                    value: crop.updatedAt != null
                        ? "${crop.updatedAt!.day}/${crop.updatedAt!.month}/${crop.updatedAt!.year}"
                        : 'N/A',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No results found'));
  }
}
