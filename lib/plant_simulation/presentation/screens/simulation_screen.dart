import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/main_home.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/region_model.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/simulation_detail_screen.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/drop_down_soiltype.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/drow_down_region.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  // Controllers
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _plantTypeController = TextEditingController();
  final TextEditingController _soilTypeController = TextEditingController();
  final TextEditingController _farmAreaController = TextEditingController();
  final TextEditingController _seasonController = TextEditingController();
  Region? _selectedRegion;
  String _selectedSoilType = '';
  String? _locationError;
  String? _soilTypeError;
  // Date picker
  DateTime _selectedDate = DateTime.now();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Focus nodes for better UX
  final FocusNode _farmNameFocus = FocusNode();
  final FocusNode _plantTypeFocus = FocusNode();
  final FocusNode _soilTypeFocus = FocusNode();
  final FocusNode _farmAreaFocus = FocusNode();
  final FocusNode _seasonFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SimulationBloc>().add(ResetSimulationEvent());
    });
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _plantTypeController.dispose();
    _soilTypeController.dispose();
    _farmAreaController.dispose();
    _seasonController.dispose();
    _farmNameFocus.dispose();
    _plantTypeFocus.dispose();
    _soilTypeFocus.dispose();
    _farmAreaFocus.dispose();
    _seasonFocus.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.grey.shade900,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    setState(() {
      _locationError = _selectedRegion == null
          ? 'တိုင်းဒေသကြီး/ပြည်နယ် ရွေးချယ်ပါ'
          : null;
      _soilTypeError = _selectedSoilType.isEmpty
          ? 'မြေအမျိုးအစား ရွေးချယ်ပါ'
          : null;
    });

    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || _locationError != null || _soilTypeError != null) {
      return;
    }

    final plantingDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    context.read<SimulationBloc>().add(
      CreateSimulationEvent(
        farmName: _farmNameController.text.trim(),
        plantType: _plantTypeController.text.trim(),
        soilType: _selectedSoilType,
        plantArea: _farmAreaController.text.trim(),
        plantingdate: plantingDate,
        location: _selectedRegion!.nameMm,
        season: _seasonController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 360 ? 16.0 : 24.0;

    return Scaffold(
      body: BlocConsumer<SimulationBloc, SimulationState>(
        listenWhen: (previous, current) =>
            current is CreateSimulationSuccess ||
            current is CreateSimulationFailure,
        listener: (context, state) {
          if (state is CreateSimulationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Simulation created successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SimulationSuccessScreen(
                  simulation: state.farmSimulation,
                ),
              ),
            );
          } else if (state is CreateSimulationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.message.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is SimulationInitial ||
            current is CreateSimulationLoading ||
            current is CreateSimulationSuccess ||
            current is CreateSimulationFailure,
        builder: (context, state) {
          if (state is CreateSimulationLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'Creating Simulation...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state is CreateSimulationSuccess) {
            return _buildSuccessScreen(state);
          }

          // Keep form visible on create failure (snackbar already shown).
          return _buildFormScreen(horizontalPadding: horizontalPadding);
        },
      ),
    );
  }

  Widget _buildFormScreen({double horizontalPadding = 24}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade50, Colors.white],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                RegionDropdown(
                  label: 'တိုင်းဒေသကြီး/ပြည်နယ်',
                  hintText: 'ကျေးဇူးပြု၍ ရွေးချယ်ပါ',
                  selectedRegion: _selectedRegion,
                  onChanged: (Region? region) {
                    setState(() {
                      _selectedRegion = region;
                      _selectedSoilType = '';
                      _locationError = null;
                      _soilTypeError = null;
                    });
                  },
                  isRequired: true,
                  errorText: _locationError,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _farmNameController,
                  focusNode: _farmNameFocus,
                  label: 'စိုက်ခင်းအမည်',
                  hint: 'စိုက်ခင်းအမည်ရေးပါ။',
                  icon: Icons.area_chart,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'စိုက်ခင်းအမည် ရေးပေးပါ';
                    }
                    if (value.trim().length < 2) {
                      return 'အမည် အနည်းဆုံး ၂ လုံးရေးပါ';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _plantTypeFocus.requestFocus(),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _plantTypeController,
                  focusNode: _plantTypeFocus,
                  label: 'အပင်အမျိုးအစား',
                  hint: 'e.g.စပါး, ငရုတ်သီး, ပြောင်းဖူး',
                  icon: Icons.grass,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'အပင်အမျိုးအစား ရေးပေးပါ';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _seasonFocus.requestFocus(),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _seasonController,
                  focusNode: _seasonFocus,
                  label: 'ရာသီဥတု',
                  hint: 'e.g. မိုးရာသီ,ဆောင်းရာသီ,နွေရာသီ',
                  icon: Icons.wb_sunny_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'လက်ရှိရာသီဥတုကိုရေးပေးပါ။';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _farmAreaFocus.requestFocus(),
                ),
                const SizedBox(height: 16),
                SoilTypeDropdown(
                  label: 'မြေအမျိုးအစား',
                  hintText: 'သင့်တော်သော မြေအမျိုးအစားကို ရွေးပါ',
                  selectedRegion: _selectedRegion,
                  selectedSoilType: _selectedSoilType,
                  onChanged: (String soilType) {
                    setState(() {
                      _selectedSoilType = soilType;
                      _soilTypeError = null;
                    });
                  },
                  isRequired: true,
                  errorText: _soilTypeError,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _farmAreaController,
                  focusNode: _farmAreaFocus,
                  label: 'စိုက်ခင်းအကျယ်',
                  hint: 'ဧက အရေအတွက်',
                  icon: Icons.square_foot,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'စိုက်ခင်းအကျယ်ရေးပေးပါ';
                    }
                    final area = double.tryParse(
                      value.trim().replaceAll(',', ''),
                    );
                    if (area == null || area <= 0) {
                      return 'မှန်ကန်သော ကိန်းဂဏန်း ရေးပေးပါ';
                    }
                    if (area > 100000) {
                      return 'ဧရိယာ တန်ဖိုး များလွန်းနေပါသည်';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _selectDate(context),
                ),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 28),
                _buildSubmitButton(),
                const SizedBox(height: 16),
                _buildAdditionalInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smart Farming Simulation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'သက်ဆိုင်ရာ အချက်အလက် များကိုဖြည့်ပါ။',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.green.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade700, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    final isCompact = MediaQuery.sizeOf(context).width < 380;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'စိုက်ပျိုးမည့်ရက်',
            prefixIcon: Icon(
              Icons.calendar_today,
              color: Colors.green.shade700,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade700, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat(
                    isCompact ? 'MMM d, yyyy' : 'EEEE, MMMM d, yyyy',
                  ).format(_selectedDate),
                  style: TextStyle(fontSize: isCompact ? 13 : 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: 14, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'ရွေးရန်',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: Colors.green.shade300,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'ခန့်မှန်းချက်များထုတ်မည်',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width < 360 ? 15 : 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'All fields are required. Please ensure you have accurate information for the best simulation results.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen(CreateSimulationSuccess state) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade50, Colors.white],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const SizedBox(height: 24),
                // const Text(
                //   '  ေအာင်မြင်ပါသည်',
                //   style: TextStyle(
                //     fontSize: 28,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black87,
                //   ),
                // ),
                const SizedBox(height: 8),
                Text(
                  'သင့်ရဲ့ စိုက်ခင်းကို AI Alert စိုက်ပျိုးရေး စနစ်    အတွင်း ထည့်ပြီးပါပြီ။',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Farm Id',
                        state.farmSimulation.id.toString(),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'လယ်ယာအမည်',
                        state.farmSimulation.farmName.toString(),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'အပင်အမျိုးအစား',
                        state.farmSimulation.riceType.toString(),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'မြေအမျိုးအစား',
                        state.farmSimulation.soilType.toString(),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'စိုက်ပျိုးမည့်ရက်',
                        () {
                          try {
                            return DateFormat('MMM d, yyyy').format(
                              DateTime.parse(
                                state.farmSimulation.plantingDate.toString(),
                              ),
                            );
                          } catch (_) {
                            return state.farmSimulation.plantingDate
                                    ?.toString() ??
                                'N/A';
                          }
                        }(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<SimulationBloc>().add(
                            ResetSimulationEvent(),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MainHome()),
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green.shade700,
                          side: BorderSide(color: Colors.green.shade700),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'နောက်တစ်ခု ဖန်တီးရန်',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to simulation details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimulationSuccessScreen(
                                simulation: state.farmSimulation,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'ရလဒ်များ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}