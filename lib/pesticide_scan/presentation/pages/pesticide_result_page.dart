// import 'package:flutter/material.dart';
// import 'package:plant_scanner_app/pesticide_scan/domain/entity/pesticide_entity.dart';

// class PesticideResultPage extends StatelessWidget {
//   final PesticideScanResult result;

//   const PesticideResultPage({super.key, required this.result});

//   @override
//   Widget build(BuildContext context) {
//     final guide = result.guide;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       // appBar: AppBar(
//       //   title: const Text('ပိုးသတ်ဆေး စစ်ဆေးမှု ရလဒ်'),
//       //   backgroundColor: Colors.green[800],
//       //   foregroundColor: Colors.white,
//       //   elevation: 0,
//       // ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Status Card (Approved Status)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: result.status == 'APPROVED'
//                     ? Colors.green[50]
//                     : Colors.red[50],
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: result.status == 'APPROVED'
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     result.status == 'APPROVED'
//                         ? Icons.check_circle
//                         : Icons.warning_rounded,
//                     color: result.status == 'APPROVED'
//                         ? Colors.green[700]
//                         : Colors.red[700],
//                     size: 28,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       result.message,
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: result.status == 'APPROVED'
//                             ? Colors.green[900]
//                             : Colors.red[900],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Summary Section
//             _buildSectionCard(
//               title: "အကျဉ်းချုပ်",
//               icon: Icons.info_outline_rounded,
//               child: Text(
//                 guide.summary,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   height: 1.5,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Target Pests & Used For
//             _buildSectionCard(
//               title: "ကာကွယ်နှိမ်နင်းနိုင်သော ပိုးမွှားများ",
//               icon: Icons.bug_report_outlined,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "သုံးစွဲရန်: ${guide.usedFor}",
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     children: guide.targetPests
//                         .map(
//                           (pest) => Chip(
//                             label: Text(
//                               pest,
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                             backgroundColor: Colors.green[50],
//                             side: BorderSide(color: Colors.green[200]!),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),

//             // How to use
//             _buildSectionCard(
//               title: "အသုံးပြုနည်း လမ်းညွှန်",
//               icon: Icons.integration_instructions_outlined,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "ဆေးပမာဏ: ${guide.dosage}",
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "အကောင်းဆုံး ဖျန်းရန်အချိန်: ${guide.bestApplicationTime}",
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   const Divider(height: 20),
//                   ...guide.howToUse.map(
//                     (step) => Padding(
//                       padding: const EdgeInsets.only(bottom: 6.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(
//                             Icons.check_box_sharp,
//                             color: Colors.green,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               step,
//                               style: const TextStyle(fontSize: 13),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Safety & Equipment
//             _buildSectionCard(
//               title: "ဝတ်ဆင်ရန် ကာကွယ်ရေး ပစ္စည်းများ",
//               icon: Icons.security_rounded,
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 4,
//                 children: guide.protectiveEquipment
//                     .map(
//                       (item) => Chip(
//                         avatar: const Icon(
//                           Icons.shield_outlined,
//                           size: 16,
//                           color: Colors.orange,
//                         ),
//                         label: Text(item, style: const TextStyle(fontSize: 12)),
//                         backgroundColor: Colors.orange[50],
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionCard({
//     required String title,
//     required IconData icon,
//     required Widget child,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.withOpacity(0.12)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.green[800], size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const Divider(height: 20),
//           child,
//         ],
//       ),
//     );
//   }
// }
