import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_scanner_app/plant_scan/presentation/crop_prices/crop_prices_bloc.dart';

class CropMarketScreen extends StatefulWidget {
  const CropMarketScreen({super.key});

  @override
  State<CropMarketScreen> createState() => _CropMarketScreenState();
}

class _CropMarketScreenState extends State<CropMarketScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the event to fetch crop market data when the screen is initialized

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CropPricesBloc>().add(GetCropMarketEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropPricesBloc, CropPricesState>(
      builder: (context, state) {
        if (state is CropPricesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CropPricesLoadedErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.errorMessage}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<CropPricesBloc>().add(GetCropMarketEvent());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        } else if (state is CropPricesLoadedState) {
          final cropMarkets = state.cropmarkets;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: cropMarkets.length,
            itemBuilder: (context, index) {
              final cropMarket = cropMarkets[index];
              return Card(
                child: ListTile(
                  title: Text(cropMarket.name),
                  subtitle: Text(
                    'Price: ${cropMarket.minPrice} - ${cropMarket.maxPrice}',
                  ),
                ),
              );
            },
          );
        }
        return Center(child: Text("CropMarket"));
      },
    );
  }
}
