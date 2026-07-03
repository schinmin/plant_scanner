import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_scanner_app/plant_scan/presentation/crop_prices/crop_prices_bloc.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/crop_market_screen.dart';
import 'package:plant_scanner_app/plant_scan/presentation/scan/bloc/getapiresponse_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text('Plant Scanner Home'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<GetapiresponseBloc, GetapiresponseState>(
        builder: (context, state) {
          if (state is GetapiresponseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetapiresponseFailure) {
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
                      context.read<GetapiresponseBloc>().add(
                        const PickAndScanEvent(),
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (state is GetapiresponseSuccess) {
            final response = state.aiResponse;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🌿 Diagnosis Result',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'Disease: ${response.diseaseNameEng}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ရောဂါအမည် : ${response.diseaseNameMM}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                'Confidence: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${response.confidencePercentage}%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🛠️ Treatment Steps',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          ...response.treatementSteps.asMap().entries.map((
                            entry,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${entry.key + 1}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(entry.value)),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<GetapiresponseBloc>().add(
                        const PickAndScanEvent(),
                      );
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan Another Plant'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  // FIXED BUTTON - Option 1: Using BlocProvider.value
                  ElevatedButton.icon(
                    onPressed: () {
                      // Get the bloc from current context
                      final cropPricesBloc = context.read<CropPricesBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: cropPricesBloc,
                            child: const CropMarketScreen(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.attach_money),
                    label: const Text('Crop Market Prices'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      minimumSize: const Size(200, 50),
                    ),
                  ),
                ],
              ),
            );
          }

          // Initial state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.agriculture, size: 80, color: Colors.green.shade300),
                const SizedBox(height: 24),
                const Text(
                  'Plant Disease Diagnosis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Take a photo or select from gallery\nto diagnose plant diseases',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () => context.read<GetapiresponseBloc>().add(
                    const PickAndScanEvent(),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Start Diagnosis'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                ),
                const SizedBox(height: 16),
                // FIXED BUTTON - Option 1: Using BlocProvider.value
                ElevatedButton.icon(
                  onPressed: () {
                    final cropPricesBloc = context.read<CropPricesBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cropPricesBloc,
                          child: const CropMarketScreen(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.attach_money),
                  label: const Text('Crop Market Prices'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:plant_scanner_app/plant_scan/presentation/crop_prices/crop_prices_bloc.dart';
// import 'package:plant_scanner_app/plant_scan/presentation/pages/crop_market_screen.dart';
// import 'package:plant_scanner_app/plant_scan/presentation/scan/bloc/getapiresponse_bloc.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(),
//       appBar: AppBar(
//         title: const Text('Plant Scanner Home'),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocBuilder<GetapiresponseBloc, GetapiresponseState>(
//         builder: (context, state) {
//           if (state is GetapiresponseLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is GetapiresponseFailure) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text('Error: ${state.errorMessage}'),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<GetapiresponseBloc>().add(
//                         const PickAndScanEvent(),
//                       );
//                     },
//                     child: const Text('Try Again'),
//                   ),
//                 ],
//               ),
//             );
//           } else if (state is GetapiresponseSuccess) {
//             final response = state.aiResponse;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             '🌿 Diagnosis Result',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Divider(),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Disease: ${response.diseaseNameEng}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'ရောဂါအမည် : ${response.diseaseNameMM}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               const Text(
//                                 'Confidence: ',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               Text(
//                                 '${response.confidencePercentage}%',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             '🛠️ Treatment Steps',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Divider(),
//                           const SizedBox(height: 8),
//                           ...response.treatementSteps.asMap().entries.map((
//                             entry,
//                           ) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width: 24,
//                                     height: 24,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green.shade100,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         '${entry.key + 1}',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.green.shade800,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(child: Text(entry.value)),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       context.read<GetapiresponseBloc>().add(
//                         const PickAndScanEvent(),
//                       );
//                     },
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('Scan Another Plant'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BlocProvider<CropPricesBloc>(
//                           create: (context) => context.read<CropPricesBloc>(),
//                           child: const CropMarketScreen(),
//                         ),
//                       ),
//                     ),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('Crop Market Prices'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 32,
//                         vertical: 16,
//                       ),
//                       minimumSize: const Size(200, 50),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // Initial state
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.agriculture, size: 80, color: Colors.green.shade300),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Plant Disease Diagnosis',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Take a photo or select from gallery\nto diagnose plant diseases',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 48),
//                 ElevatedButton.icon(
//                   onPressed: () => context.read<GetapiresponseBloc>().add(
//                     const PickAndScanEvent(),
//                   ),
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Start Diagnosis'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 16,
//                     ),
//                     minimumSize: const Size(200, 50),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) {
//                         context.read<CropPricesBloc>().add(
//                           GetCropMarketEvent(),
//                         );

//                         return const CropMarketScreen();
//                       },
//                     ),
//                   ),
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Crop Market Prices'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 16,
//                     ),
//                     minimumSize: const Size(200, 50),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showImagePickerOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 12),
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, size: 30),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   context.read<GetapiresponseBloc>().add(
//                     const PickAndScanEvent(),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, size: 30),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   context.read<GetapiresponseBloc>().add(
//                     const PickAndScanEvent(),
//                   );
//                 },
//               ),
//               const SizedBox(height: 12),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
