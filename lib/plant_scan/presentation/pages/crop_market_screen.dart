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
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CropPricesBloc, CropPricesState>(
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
                        context.read<CropPricesBloc>().add(
                          GetCropMarketEvent(),
                        );
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is CropPricesLoadedState) {
              final cropMarkets = state.cropmarkets;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "မြန်မာနိုင်ငံ ရှိ သီးနှံ စျေးနှုန်းများ - ${DateTime.now().year}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: cropMarkets.length,
                      itemBuilder: (context, index) {
                        final crop = cropMarkets[index];
                        return Card(
                          child: ListTile(
                            titleAlignment: ListTileTitleAlignment.top,
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(crop.name),
                            ),
                            subtitle: Text(crop.location),
                            trailing: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "${crop.minPrice} - ${crop.maxPrice} ${crop.currency}",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Center(child: Text("CropMarket"));
          },
        ),
      ),
    );
  }
}
