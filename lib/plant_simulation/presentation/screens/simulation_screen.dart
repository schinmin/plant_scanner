import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/simulation_detail_screen.dart';

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

  // Date picker
  DateTime _selectedDate = DateTime.now();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Focus nodes for better UX
  final FocusNode _farmNameFocus = FocusNode();
  final FocusNode _plantTypeFocus = FocusNode();
  final FocusNode _soilTypeFocus = FocusNode();
  final FocusNode _farmAreaFocus = FocusNode();

  @override
  void dispose() {
    _farmNameController.dispose();
    _plantTypeController.dispose();
    _soilTypeController.dispose();
    _farmAreaController.dispose();
    _farmNameFocus.dispose();
    _plantTypeFocus.dispose();
    _soilTypeFocus.dispose();
    _farmAreaFocus.dispose();
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
    if (_formKey.currentState!.validate()) {
      // Dispatch event to BLoC
      context.read<SimulationBloc>().add(
        CreateSimulationEvent(
          farmName: _farmNameController.text.trim(),
          plantType: _plantTypeController.text.trim(),
          soilType: _soilTypeController.text.trim(),
          plantArea: _farmAreaController.text.trim(),
          plantingdate: _selectedDate.toString(),
        ),
      );

      // Show loading feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Creating simulation...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SimulationBloc, SimulationState>(
        listener: (context, state) {
          if (state is SimulationLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✅ Simulation created successfully!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SimulationSuccessScreen(simulation: state.farmSimulation),
              ),
            );
          } else if (state is SimulationLoadedError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.message.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          debugPrint("State : $state");
          if (state is SimulationLoading) {
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

          if (state is SimulationLoaded) {
            return _buildSuccessScreen(state);
          }

          return _buildFormScreen();
        },
      ),
    );
  }

  Widget _buildFormScreen() {
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
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 32),

                // Farm Name Field
                _buildTextField(
                  controller: _farmNameController,
                  focusNode: _farmNameFocus,
                  label: 'Farm Name',
                  hint: 'Enter your farm name',
                  icon: Icons.area_chart,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter farm name';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _plantTypeFocus.requestFocus(),
                ),
                const SizedBox(height: 20),

                // Plant Type Field
                _buildTextField(
                  controller: _plantTypeController,
                  focusNode: _plantTypeFocus,
                  label: 'Plant Type',
                  hint: 'e.g., Rice, Wheat, Corn',
                  icon: Icons.grass,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter plant type';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _soilTypeFocus.requestFocus(),
                ),
                const SizedBox(height: 20),

                // Soil Type Field
                _buildTextField(
                  controller: _soilTypeController,
                  focusNode: _soilTypeFocus,
                  label: 'Soil Type',
                  hint: 'e.g., Clay Loam, Sandy, Silty',
                  icon: Icons.landscape,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter soil type';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _farmAreaFocus.requestFocus(),
                ),
                const SizedBox(height: 20),

                // Farm Area Field
                _buildTextField(
                  controller: _farmAreaController,
                  focusNode: _farmAreaFocus,
                  label: 'Farm Area',
                  hint: 'Enter area in acres',
                  icon: Icons.square_foot,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter farm area';
                    }
                    final area = double.tryParse(value.trim());
                    if (area == null || area <= 0) {
                      return 'Please enter a valid positive number';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _selectDate(context),
                ),
                const SizedBox(height: 20),

                // Planting Date Field
                _buildDatePicker(),
                const SizedBox(height: 32),

                // Submit Button
                _buildSubmitButton(),
                const SizedBox(height: 16),

                // Additional Info
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
                      'Create New Simulation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Fill in the details below to start your farm simulation',
                      style: TextStyle(
                        fontSize: 14,
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
            labelText: 'Planting Date',
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
              horizontal: 5,
              vertical: 16,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                style: const TextStyle(fontSize: 10),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Change',
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
          children: const [
            Icon(Icons.play_arrow, size: 24),
            SizedBox(width: 8),
            Text(
              'Start Simulation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildSuccessScreen(SimulationLoaded state) {
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
                        DateFormat('MMM d, yyyy').format(
                          DateTime.parse(
                            state.farmSimulation.plantingDate.toString(),
                          ),
                        ),
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
                          // // Reset to form
                          // context.read<SimulationBloc>().add(
                          //   ResetSimulationEvent(),
                          // );
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Colors.green.shade700),
            const SizedBox(width: 8),
            const Text('How to Use'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              '🌾 Farm Name',
              'Give your farm a unique name for identification',
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              '🌱 Plant Type',
              'Select the type of crop you want to simulate',
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              '🧪 Soil Type',
              'Choose the soil type for accurate growth predictions',
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              '📐 Farm Area',
              'Enter the size of your farm in acres',
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              '📅 Planting Date',
              'Select when you plan to start planting',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            description,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }
}
