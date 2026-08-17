import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_scanner_app/auth/presentation/bloc/auth_bloc.dart';
import 'package:plant_scanner_app/auth/presentation/screens/login_screen.dart';
import 'package:plant_scanner_app/auth/presentation/widgets/auth_button.dart';
import 'package:plant_scanner_app/auth/presentation/widgets/auth_text_field.dart';
import 'package:plant_scanner_app/core/di/injection.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/main_home.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/welther_screen.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    debugPrint("Register Action");
    debugPrint("Name : ${_nameController.text}");
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterRequest(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          fcmToken: null, // Add FCM token if needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1F8E9), Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              debugPrint("Auth State Changed: $state");
              if (state is AuthError) {
                debugPrint(
                  "Error Registeration : ${state.failure.message.runtimeType}",
                );
                _showErrorDialog(context, state.failure.message);
              } else if (state is AuthRegisterSuccess) {
                _showSuccessDialog(context, state);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button

                      // Header
                      _buildHeader(),
                      const SizedBox(height: 30),

                      // Form Fields
                      _buildForm(),
                      const SizedBox(height: 24),

                      // Register Button
                      AuthButton(
                        onPressed: _register,
                        isLoading: state is AuthLoading,
                        text: 'အကောင့်ဖွင့်မည်',
                        icon: Icons.agriculture,
                      ),
                      // ElevatedButton(
                      //   onPressed: _register,
                      //   child: Text("Register"),
                      // ),
                      const SizedBox(height: 16),

                      // Login Link
                      _buildLoginLink(),
                      const SizedBox(height: 20),

                      // Footer
                      _buildFooter(),
                    ],
                  ),
                ),
              );
            },
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
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 40,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.eco, color: Colors.green, size: 35),
                ),
                const SizedBox(width: 8),
                Center(
                  child: const Text(
                    'Smart Farming Simulation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'အကောင့်အသစ် ဖွင့်မည်',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'စိုက်ပျိုးရေး အချက်အလက်များကို လေ့လာရန် အကောင့်ဖွင့်ပါ',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.agriculture, color: Colors.orange.shade700, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ကျေးလက်ဒေသများတွင် စိုက်ပျိုးရေး အချက်အလက်များကို လွယ်ကူစွာ လေ့လာနိုင်ပါသည်',
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        AuthTextField(
          controller: _nameController,
          label: 'အမည်',
          hint: 'သင့်အမည်ကို ထည့်ပါ',
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ အမည်ထည့်ပါ';
            }
            if (value.length < 2) {
              return 'အမည်သည် အနည်းဆုံး ၂ လုံးရှိရပါမည်';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _phoneController,
          label: 'ဖုန်းနံပါတ်',
          hint: 'ဖုန်းနံပါတ် ထည့်ပါ (ဥပမာ- 09123456789)',
          prefixIcon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ ဖုန်းနံပါတ်ထည့်ပါ';
            }
            if (value.length < 10 || value.length > 11) {
              return 'ဖုန်းနံပါတ်သည် ၁၀ လုံး သို့မဟုတ် ၁၁ လုံးရှိရပါမည်';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          label: 'စကားဝှက်',
          hint: 'စကားဝှက် ထည့်ပါ',
          prefixIcon: Icons.lock_outline,
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ စကားဝှက်ထည့်ပါ';
            }
            if (value.length < 6) {
              return 'စကားဝှက် အနည်းဆုံး ၆ လုံးရှိရပါမည်';
            }
            if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
              return 'စကားဝှက်တွင် စာလုံးနှင့် ဂဏန်း ပါရပါမည်';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _confirmPasswordController,
          label: 'စကားဝှက် အတည်ပြုရန်',
          hint: 'စကားဝှက်ကို ထပ်ထည့်ပါ',
          prefixIcon: Icons.lock_outline,
          obscureText: !_isConfirmPasswordVisible,
          suffixIcon: IconButton(
            onPressed: () {
              setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              );
            },
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'ကျေးဇူးပြု၍ စကားဝှက်အတည်ပြုပါ';
            }
            if (value != _passwordController.text) {
              return 'စကားဝှက် နှစ်ခုမတူပါ';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'အကောင့်ရှိပြီးသားလား?',
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            'ဝင်မည်',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.grass, color: Colors.green.shade700, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'အကောင့်ဖွင့်ခြင်းဖြင့် ကျွန်ုပ်တို့၏ စည်းကမ်းချက်များကို လက်ခံပါသည်',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  // ============ Dialog Methods ============

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text('မှားယွင်းမှု'),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('ပြန်ကြိုးစားမည်'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, AuthRegisterSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'အကောင့်ဖွင့်ခြင်း အောင်မြင်ပါသည်!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'မင်္ဂလာပါ! သင်၏ အကောင့်ကို အောင်မြင်စွာ ဖွင့်လှစ်နိုင်ပါပြီ။',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // User Info Cards
                _buildUserInfoCard(
                  icon: Icons.person,
                  iconColor: Colors.green.shade700,
                  bgColor: Colors.green.shade50,
                  label: 'အမည်',
                  value: state.user.name,
                ),
                const SizedBox(height: 8),

                _buildUserInfoCard(
                  icon: Icons.phone,
                  iconColor: Colors.blue.shade700,
                  bgColor: Colors.blue.shade50,
                  label: 'ဖုန်း',
                  value: state.user.phone,
                ),
                const SizedBox(height: 16),

                // Agriculture Tip
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade50, Colors.orange.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.agriculture,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          ' AI Alertစိုက်ပျိုးရေး ကို စတင်အသုံးပြုနိုင်ပါပြီ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFE65100),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => sl<SimulationBloc>(),
                            child: const MainHome(),
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'စတင်လေ့လာမည်',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for user info cards
  Widget _buildUserInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
