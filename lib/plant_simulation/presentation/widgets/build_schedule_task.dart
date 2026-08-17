import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/helper.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/schedule_task_entity.dart';

Widget buildScheduleTasks({
  required BuildContext context,
  required List<ScheduleTaskEntity> scheduleTasks,
  required DateTime plantingDate,
  required String farmName,
}) {
  if (scheduleTasks.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.event_note_rounded, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              '$farmName ၏\nစိုက်ပျိုးရေး လုပ်ငန်းစဉ် အချိန်ဇယား',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: scheduleTasks.length,
        itemBuilder: (context, index) {
          final task = scheduleTasks[index];
          final days = task.dayAfterPlanting;
          final title = task.taskTitle;
          final description = task.description;
          final taskType = task.taskType;

          // Calculate scheduled date based on planting_date
          //final taskScheduledDate = plantingDate.add(Duration(days: days));
          //final formattedDate = DateFormat('MMM dd, yyyy').format(taskScheduledDate);

          final isLast = index == scheduleTasks.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Timeline Indicator (Day Badge & Line)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTaskColor(taskType).withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getTaskColor(taskType),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getTaskIcon(taskType),
                        size: 20,
                        color: _getTaskColor(taskType),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(width: 2, color: Colors.grey.shade300),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // 2. Task Details Card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Day counter badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  days == '0'
                                      ? dateFormat(plantingDate)
                                      : '$days ရက်မြောက်',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ),

                              // Computed Date
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

// Helper to determine Task Icon
IconData _getTaskIcon(String taskType) {
  switch (taskType.toUpperCase()) {
    case 'fertilizing':
    case 'မြေဩဇာကျွေးခြင်း':
      return Icons.science_outlined;
    case 'irrigation':
    case 'ရေသွင်းခြင်း':
      return Icons.water_drop_outlined;
    case 'pesticide':
    case 'ပိုးမွှားကာကွယ်ခြင်း':
      return Icons.bug_report_outlined;
    case 'land_perparation':
    case 'ပေါင်းရှင်းခြင်း':
      return Icons.grass_outlined;
    case 'harvesting':
    case 'ရိတ်သိမ်းခြင်း':
      return Icons.agriculture_outlined;
    default:
      return Icons.task_alt_rounded;
  }
}

// Helper to determine Task Color
Color _getTaskColor(String taskType) {
  switch (taskType.toUpperCase()) {
    case 'fertilizing':
    case 'မြေဩဇာကျွေးခြင်း':
      return Colors.amber.shade800;
    case 'irrigation':
    case 'ရေသွင်းခြင်း':
      return Colors.blue;
    case 'pesticide':
    case 'ပိုးမွှားကာကွယ်ခြင်း':
      return Colors.red.shade600;
    case 'land_preparation':
    case 'ပေါင်းရှင်းခြင်း':
      return Colors.teal;
    case 'harvesting':
    case 'ရိတ်သိမ်းခြင်း':
      return Colors.orange.shade800;
    default:
      return Colors.green;
  }
}

// "schedule_tasks": [
//             {
//                 "days_after_planting": 0,
//                 "title": "မြေပြင်ခြင်း",
//                 "description": "လယ်မြေကို ပြင်ဆင်ပြီး လယ်ထွန်ခြင်းလုပ်ငန်းများ ဆောင်ရွက်ရန်။",
//                 "task_type": "land_preparation",
//                 "_id": "6a7dae0198208ba474da6d51"
//             },
//             {
//                 "days_after_planting": 0,
//                 "title": "မျိုးစေ့စိုက်ခြင်း",
//                 "description": "အရည်အသွေးကောင်းမွန်သော နှင်းဆီပင်မျိုးစေ့များကို စိုက်ရန်။",
//                 "task_type": "seeding",
//                 "_id": "6a7dae0198208ba474da6d52"
//             },
//             {
//                 "days_after_planting": 10,
//                 "title": "ဓာတ်မြေသြဇာ ပထမအကြိမ်",
//                 "description": "Urea 20 kg တစ်ဧကနှင့် မြေသြဇာပေးရန်။",
//                 "task_type": "fertilizing",
//                 "_id": "6a7dae0198208ba474da6d53"
//             },
//             {
//                 "days_after_planting": 20,
//                 "title": "ပိုးမွှားကာကွယ်ဆေးပေးခြင်း",
//                 "description": "ပိုးမွှားများကို ထိန်းချုပ်ရန် ပိုးသတ်ဆေးများ သုံးစွဲရန်။",
//                 "task_type": "pesticide",
//                 "_id": "6a7dae0198208ba474da6d54"
//             },
//             {
//                 "days_after_planting": 30,
//                 "title": "ဓာတ်မြေသြဇာ ဒုတိယအကြိမ်",
//                 "description": "T-Super 30 kg တစ်ဧကနှင့် မြေသြဇာပေးရန်။",
//                 "task_type": "fertilizing",
//                 "_id": "6a7dae0198208ba474da6d55"
//             },
//             {
//                 "days_after_planting": 40,
//                 "title": "ရေသွင်းခြင်း",
//                 "description": "မိုးရွာမှုမရှိသောအချိန်များတွင် ရေစက်စနစ်ဖြင့် ရေထည့်ပေးရန်။",
//                 "task_type": "irrigation",
//                 "_id": "6a7dae0198208ba474da6d56"
//             },
//             {
//                 "days_after_planting": 50,
//                 "title": "ဓာတ်မြေသြဇာ တတိယအကြိမ်",
//                 "description": "Potash 25 kg တစ်ဧကနှင့် မြေသြဇာပေးရန်။",
//                 "task_type": "fertilizing",
//                 "_id": "6a7dae0198208ba474da6d57"
//             },
//             {
//                 "days_after_planting": 60,
//                 "title": "ပိုးမွှားနှင့် ရောဂါကာကွယ်ဆေးပေးခြင်း",
//                 "description": "ပိုးမွှားနှင့် ရောဂါများကို ထိန်းချုပ်ရန် ဆေးပေးခြင်း။",
//                 "task_type": "pesticide",
//                 "_id": "6a7dae0198208ba474da6d58"
//             },
//             {
//                 "days_after_planting": 90,
//                 "title": "ရိတ်သိမ်းခြင်း",
//                 "description": "ဆန်စပါးများကို သေချာစွာ ရိတ်သိမ်းပြီး သန့်ရှင်းသောနေရာတွင် သိမ်းဆည်းရန်။",
//                 "task_type": "harvesting",
//                 "_id": "6a7dae0198208ba474da6d59"
//             }
