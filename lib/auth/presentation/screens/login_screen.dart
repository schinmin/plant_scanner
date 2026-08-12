import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:plant_scanner_app/auth/presentation/bloc/auth_bloc.dart';

import 'package:plant_scanner_app/auth/presentation/widgets/auth_button.dart';
import 'package:plant_scanner_app/auth/presentation/widgets/auth_text_field.dart';
import 'package:plant_scanner_app/auth/presentation/screens/register_screen.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/main_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ Get FCM Token
  // Future<void> _getFcmToken() async {
  //   _fcmToken = await FcmTokenHelper.getToken();
  //   debugPrint('📱 FCM Token: $_fcmToken');
  // }

  // ✅ Login Method
  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequest(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          fcmToken: _fcmToken,
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
            colors: [
              Color(0xFFF1F8E9), // Light green
              Color(0xFFE8F5E9),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                _showErrorDialog(context, state.failure.message);
              } else if (state is AuthLoginSuccess) {
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
                      // // Back Button
                      // IconButton(
                      //   onPressed: () => Navigator.pop(context),
                      //   icon: const Icon(Icons.arrow_back_ios, size: 20),
                      //   padding: EdgeInsets.zero,
                      //   alignment: Alignment.centerLeft,
                      // ),
                      // const SizedBox(height: 10),

                      // Header
                      _buildHeader(),
                      const SizedBox(height: 30),

                      // Form Fields
                      _buildForm(),
                      const SizedBox(height: 8),

                      // Forgot Password
                      _buildForgotPassword(),
                      const SizedBox(height: 24),

                      // Login Button
                      AuthButton(
                        onPressed: _login,
                        isLoading: state is AuthLoading,
                        text: 'ဝင်မည်',
                        icon: Icons.login,
                      ),
                      const SizedBox(height: 16),

                      // Register Link
                      _buildRegisterLink(),
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

  // ============ Header Widget ============
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.eco, color: Colors.green, size: 35),
              ),
              const SizedBox(width: 8),
              const Text(
                'AI Alert စိုက်ပျိုးရေး',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'အကောင့်ဝင်ရန်',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'စိုက်ပျိုးရေး အချက်အလက်များကို ဆက်လက်လေ့လာရန်',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'အကောင့်မရှိသေးပါက အောက်တွင် "အကောင့်ဖွင့်မည်" ကို နှိပ်ပါ',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============ Form Widget ============
  Widget _buildForm() {
    return Column(
      children: [
        // Phone Field
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

        // Password Field
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
            return null;
          },
        ),
      ],
    );
  }

  // ============ Forgot Password ============
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Navigate to forgot password
          _showForgotPasswordDialog(context);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'စကားဝှက်မေ့နေပါသလား?',
          style: TextStyle(
            color: Colors.green,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ============ Register Link ============
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'အကောင့်မရှိသေးဘူးလား?',
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            'အကောင့်ဖွင့်မည်',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ============ Footer ============
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
              'အကောင့်ဝင်ခြင်းဖြင့် ကျွန်ုပ်တို့၏ စည်းကမ်းချက်များကို လက်ခံပါသည်',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  // ============ Dialogs ============

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text('ဝင်ရောက်ခြင်း မအောင်မြင်ပါ'),
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

  void _showSuccessDialog(BuildContext context, AuthLoginSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text('ဝင်ရောက်ခြင်း အောင်မြင်ပါသည်!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'မင်္ဂလာပါ! သင် အကောင့်သို့ အောင်မြင်စွာ ဝင်ရောက်နိုင်ပါပြီ။',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.green.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'အမည်: ${state.user.name}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone, color: Colors.blue.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ဖုန်း: ${state.user.phone}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainHome()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'စတင်လေ့လာမည်',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('စကားဝှက်မေ့နေပါသလား?', textAlign: TextAlign.center),
        content: const Text(
          'ကျေးဇူးပြု၍ သင့်ဖုန်းနံပါတ်ကို ထည့်ပါ။ စကားဝှက်ပြန်လည်သတ်မှတ်ရန် လင့်ခ်ကို ပေးပို့ပါမည်။',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('မလုပ်တော့ပါ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement forgot password
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('ပေးပို့မည်'),
          ),
        ],
      ),
    );
  }
}
